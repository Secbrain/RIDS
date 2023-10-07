import math
import torch
import torch.nn as nn
from torch.autograd import Variable
from binarize import *

class BinaryLinear(nn.Linear):
    def __init__(self, *kargs, **kwargs):
        super(BinaryLinear, self).__init__(*kargs, **kwargs)
        self.move = Movement()

    def forward(self, input):
        if not hasattr(self.weight, 'org'):
            self.weight.org = self.weight.data.clone()
        self.weight.data = Binarize(self.weight.org)
        out = nn.functional.linear(self.move(input), self.weight)
        return out

