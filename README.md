### RTSS_RIDS

![avatar](./overview/rids.png)

## Introduction

RIDS is a hardware-friendly Recurrent Neural Network (RNN) model that is co-designed with programmable switches. It includes: (i) rLearner focuses on implementing the model inference process which only depends on bitwise operations or integer additions/subtractions; (ii) rEnforcer is the specially designed pipeline enforcing rLearner-generated models inside the switches. This anonymous repository displays the corresponding source code for model implementation. 

## Requirements

```bash
pip install scipy
pip install numpy
pip install pandas
pip install tqdm
pip install pyecharts
pip install joblib
pip install pickle
pip install torch
```

Hardware:
- 100 GbE NIC: [DPDK-supported hardwares](https://core.dpdk.org/supported/)
  - e.g., 100 Gbps Mellanox ConnectX-5
- Tofino switch [Tofino](https://www.intel.com/content/www/us/en/products/network-io/programmable-ethernet-switch/tofino-series.html).
  - e.g., Wedge 100BF-32X

Software:
- Ubuntu 20.04.1 LTS
- Python 3.7
- [DPDK 20.11](http://git.dpdk.org/dpdk-stable/tag/?h=v20.11)
- MoonGen/Pktgen

## Packet Generator

- Install DPDK 20.11 following [Getting Started Guide for Linux](https://doc.dpdk.org/guides-20.11/linux_gsg/index.html).
- Compile DPDK applications.
- For the packet generator, can reference [MoonGen](https://github.com/emmericp/MoonGen/tree/master).


## Pipeline

![avatar](./overview/pipeline.png)

## Programmable Switches

The P4 implementation is stored in ./rEnforcer/. 

## Model Architecture

The codes for the model construction are stored in ./rLearner/ folder. 
Among them, there are a series of binarization operations, such as activation functions, linear layers, etc. 


### References
- [Mousika: Enable General In-Network Intelligence in Programmable Switches by Knowledge Distillation](https://ieeexplore.ieee.org/document/9796936/), Guorui Xie, Qing Li, Yutao Dong, Guanglin Duan, Yong Jiang, Jingpu Duan - INFOCOM 2022
- [Kitsune: An Ensemble of Autoencoders for Online Network Intrusion Detection](https://arxiv.org/abs/1802.09089), Yisroel Mirsky, Tomer Doitshman, Yuval Elovici, and Asaf Shabtai - NDSS 2018
- [Detecting Unknown Encrypted Malicious Traffic in Real Time via Flow Interaction Graph Analysis](https://www.ndss-symposium.org/ndss-paper/detecting-unknown-encrypted-malicious-traffic-in-real-time-via-flow-interaction-graph-analysis/), Chuanpu Fu, Qi Li, Ke Xu - NDSS 2023
