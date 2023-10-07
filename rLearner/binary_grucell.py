import math
import torch
import torch.nn as nn
from torch.autograd import Variable
from binarize import *
from binary_active import *
from binary_linear import *

class BinaryGRUCellModify(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, bias=False):
        super(BinaryGRUCellModify, self).__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.bias = bias
        self.x2h = BinaryLinear(input_size, 2 * hidden_size, bias=bias)
        self.move1 = Movement()
        self.fc = BinaryLinear(hidden_size, output_size, bias=False)
        self.softmax = nn.Softmax(dim=1)
        self.reset_parameters()

    def reset_parameters(self):
        std = 1.0 / math.sqrt(self.hidden_size)
        for w in self.parameters():
            if w.data.size(0) != 1:
                w.data.uniform_(-std, std)

    def forward(self, x, S1_ori, S2_ori):
        # print('x.size:', x.size())
        x = x.view(-1, x.size(0))
        gate_x = self.x2h(x)
        # gate_x = gate_x.squeeze()
        m1, m2 = gate_x.chunk(2, 1)
        m1_act = nn.Hardtanh()(m1)
        m2_act = nn.Hardtanh()(m2)
        S1_new = S1_ori + m1_act
        S2_new = S2_ori + m2_act
        F_u = BinaryActive.apply(self.move1(S1_new))
        hy = (1 - F_u) * S2_new + F_u * S2_ori
        out = self.fc(hy)
        out = self.softmax(out)
        return S1_new, S2_new, hy, out


