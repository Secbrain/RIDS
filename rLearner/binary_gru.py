import math
import torch
import torch.nn as nn
from torch.autograd import Variable
from binarize import *
from binary_active import *
from binary_linear import *
from binary_grucell import *

class BinaryGRUModelModify(nn.Module):
    def __init__(self, input_dim, hidden_dim, layer_dim, output_dim, use_cpu=True, bias=False):
        super(BinaryGRUModelModify, self).__init__()
        self.hidden_dim = hidden_dim
        self.layer_dim = layer_dim
        self.output_dim = output_dim
        self.use_cpu = use_cpu
        self.gru_cells = [BinaryGRUCellModify(input_dim, hidden_dim, output_dim) for i in range(layer_dim)]

    def forward(self, x):
        # x: (x_data, x_length)
        # print(x_data.shape,"x_data.shape")100, 28, 28
        x_data = x[0]
        x_length = x[1]
        x_label = x[2]

        if self.training:
            outs = torch.zeros(x_data.size(0), self.output_dim)
            loss = 0
            for i in range(x_data.size(0)):
                loss_single = 0
                if torch.cuda.is_available() and not self.use_cpu:
                    S1_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim).cuda())
                    S2_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim).cuda())
                else:
                    S1_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim))
                    S2_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim))
                for seq in range(x_length[i]):
                    for layer in range(self.layer_dim):
                        if layer == 0:
                            S1_ori[layer, :, :], S2_ori[layer, :, :], hn, out = self.gru_cells[layer](x_data[i, seq, :],
                                                                                                      S1_ori[layer, :, :].clone(),
                                                                                                      S2_ori[layer, :, :].clone())
                        else:
                            S1_ori[layer, :, :], S2_ori[layer, :, :], hn, out = self.gru_cells[layer](hn,
                                                                                                      S1_ori[layer, :, :].clone(),
                                                                                                      S2_ori[layer, :, :].clone())
                #     outs[i] += out
                # return torch.sigmoid(outs[:, 1])
                    loss_single += (x_label[i] - torch.sigmoid(out[0, 1]))**2
                loss += loss_single
            return loss
        else:
            predicted = torch.zeros(x_data.size(0))
            for i in range(x_data.size(0)):
                if torch.cuda.is_available() and not self.use_cpu:
                    S1_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim).cuda())
                    S2_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim).cuda())
                else:
                    S1_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim))
                    S2_ori = Variable(torch.zeros(self.layer_dim, 1, self.hidden_dim))
                for seq in range(x_length[i]):
                    for layer in range(self.layer_dim):
                        if layer == 0:
                            S1_ori[layer, :, :], S2_ori[layer, :, :], hn, out = self.gru_cells[layer](x_data[i, seq, :],
                                                                                                      S1_ori[layer, :, :].clone(),
                                                                                                      S2_ori[layer, :, :].clone())
                        else:
                            S1_ori[layer, :, :], S2_ori[layer, :, :], hn, out = self.gru_cells[layer](hn,
                                                                                                      S1_ori[layer, :, :].clone(),
                                                                                                      S2_ori[layer, :, :].clone())
                    if out[0, 1] > 0.75:
                        break
                predicted[i] = out[0, 1]
            return predicted

