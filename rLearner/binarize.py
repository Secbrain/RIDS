import math
import torch
import torch.nn as nn
from torch.autograd import Variable


class Movement(nn.Module):
    def __init__(self):
        super(Movement, self).__init__()
        self.bias = nn.Parameter(torch.zeros(1, 1), requires_grad=True)

    def forward(self, x):
        return x + self.bias


def Binarize(tensor, quant_mode='det'):
    if quant_mode == 'det':
        # return tensor.sign()
        input_copy = tensor.clone()
        input_copy[tensor.ge(-100)] = 0
        input_copy[tensor.le(-0.005)] = -1
        input_copy[tensor.ge(0.005)] = 1
        return input_copy
    else:
        return tensor.add_(1).div_(2).add_(torch.rand(tensor.size()).add(-0.5)).clamp_(0, 1).round().mul_(2).add_(-1)
