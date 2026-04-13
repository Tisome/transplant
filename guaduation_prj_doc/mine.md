# 基于FPGA的超声波时差测量模块

## 摘要

超声波时差法具有无压损、响应速度快等特点，在流体测量领域具有较高的应用价值。该方法的关键在于准确提取顺流与逆流传播过程中的微小时间差，因此前级信号处理能力与时间差解算精度直接影响系统性能。针对传统处理平台在高速数据处理和实时性方面存在的不足，本文以“基于FPGA的超声波时差测量模块”为题，开展超声波时差测量模块的设计与实现研究。

本文采用 FPGA 与 MCU 协同架构完成系统设计。前级在 FPGA 中实现相关峰值搜索、索引提取和特征包输出，后级在 MCU 中依据峰值索引及邻域三点数据进行抛物线插值，完成传播时间差解算，并进一步实现流量换算与结果平滑输出。开发过程中结合 MATLAB 建立含噪时间差模型与流量变化模型，用于复现后级计算流程；同时在 `GD32F303RCT6` 平台上完成特征包接收与算法联调。该方法避免了整段波形直接传输带来的带宽与计算压力，兼顾了测量精度与工程实现复杂度。

结果表明，所设计的超声波时差测量模块能够较为稳定地完成特征提取、时间差解算及后续流量输出，整条测量链路具有较好的实时性和可实现性。在当前无法进行实际管道装配实测的条件下，MATLAB 仿真与板级联调结果验证了该方案的正确性与可行性，为后续系统优化和工程应用提供了基础。

**关键词**：FPGA；超声波时差测量；互相关；抛物线插值；定点验证；流量输出

## ABSTRACT

Transit-time ultrasonic measurement is widely used in flow-related applications because it offers low pressure loss and fast response. The key challenge of this method lies in accurately extracting the very small propagation-time difference between upstream and downstream signals. To address this issue, this thesis presents an FPGA-based ultrasonic time-difference measurement module.

The proposed system adopts FPGA/MCU co-design. The FPGA is used for front-end high-speed feature extraction, including correlation peak search, index detection, and feature-packet output. The MCU performs parabolic interpolation and transit-time difference calculation based on the peak index and its three neighboring samples, and then completes subsequent flow computation and output smoothing. This partition reduces waveform transmission overhead while preserving the information required for accurate time-delay estimation.

Since full pipe-mounted experiments were not available at the current stage, verification was carried out through MATLAB simulation and board-level integration. A noisy transit-time model and a flow-variation model were built in MATLAB, and the back-end calculation flow was reproduced according to the hardware-oriented implementation process. In addition, feature reception and algorithm integration were validated on the `GD32F303RCT6` platform.

The results show that the proposed module can effectively complete feature extraction, transit-time solving, and subsequent flow output, providing a practical basis for further optimization and engineering deployment.

**Keywords**: FPGA; ultrasonic transit-time measurement; cross-correlation; parabolic interpolation; fixed-point verification; flow output

## 绪论

### 研究背景与研究意义