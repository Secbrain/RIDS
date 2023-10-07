import math
import torch
import torch.nn as nn
from torch.autograd import Variable
from binarize import *

class BinaryActive(torch.autograd.Function):
    @staticmethod
    def forward(ctx, i):
        ctx.save_for_backward(i)
        # input = input.sign()
        input_copy = i.clone()
        input_copy[i.ge(0)] = 1
        input_copy[i.le(0)] = 0
        return input_copy

    @staticmethod
    def backward(ctx, grad_output):
        input, = ctx.saved_tensors
        grad_input = grad_output.clone()
        grad_input[input.ge(0.8)] = 0
        grad_input[input.le(-0.8)] = 0
        return grad_input

