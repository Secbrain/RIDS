import math
import torch
import torch.nn as nn
from torch.autograd import Variable

class GRUCellModify(nn.Module):
    def __init__(self, input_size, hidden_size, output_size, bias=False):
        super(GRUCellModify, self).__init__()
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.bias = bias
        self.x2h = nn.Linear(input_size, 2 * hidden_size, bias=bias)
        self.fc = nn.Linear(hidden_size, output_size, bias=False)
        self.softmax = nn.Softmax(dim=1)
        self.relu = nn.ReLU()
        self.tanh = nn.Tanh()
        self.reset_parameters()

    def reset_parameters(self):
        std = 1.0 / math.sqrt(self.hidden_size)
        for w in self.parameters():
            if w.data.size(0) != 1:
                w.data.uniform_(-std, std)

    def forward(self, x, S1_ori, S2_ori):
        # print('x.size in gru cell:', x.size())
        x = Variable(x.view(-1, x.size(0)).cuda())
        print(x.device)
        print('2222')
        gate_x = self.x2h(x)
        # gate_x = gate_x.squeeze()
        # print('x.size in gru cell:', x.size())
        # print('gate_x.size:', gate_x.size())
        m1, m2 = gate_x.chunk(2, 1)
        m1_act = self.tanh(m1)
        m2_act = self.tanh(m2)
        S1_new = S1_ori + m1_act
        S2_new = S2_ori + m2_act
        F_u = self.relu(S1_new)
        hy = (1 - F_u) * S2_new + F_u * S2_ori
        out = self.fc(hy)
        out = self.softmax(out)
        return S1_new, S2_new, hy, out

