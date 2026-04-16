# 第六章 MATLAB 实验与代码说明

## 1. 代码位置与总入口

第六章 MATLAB 仿真代码位于：

- `F:/matlab document/chapter6_matlab`

推荐的统一入口为：

- `main_run_all.m`

在 MATLAB 中进入该目录后，直接执行：

```matlab
results = main_run_all;
```

运行结束后会自动生成三类输出：

- `figures/`：图片文件
- `tables/`：表格文件
- `logs/`：运行摘要与配置

其中 `logs/run_summary.mat` 会保存整次运行的 `results` 和 `cfg`，便于后续复查。

当前版本的主要误差汇总表已统一输出 `Bias`、`STD`、`RMSE`、`95%` 置信区间和离群率等指标。对应表格包括 `tab_dt_snr_sweep.csv`、`tab_flow_snr_sweep.csv`、`tab_interp_compare.csv`、`tab_raw_waveform_pipeline.csv`、`tab_noise_model_compare.csv`、`tab_multivar_snr_diameter.csv`、`tab_monte_carlo_metrics.csv`、`tab_filter_compare_metrics.csv`、`tab_kalman_param_sweep.csv` 和 `tab_kalman_step_response.csv`。其中，`invalid_rate` 表示无效样本比例，`outlier_rate` 表示有效样本中超过预设误差阈值的离群比例。

## 2. 这套代码是如何模拟 FPGA 和 MCU 的

这套 MATLAB 框架并不是单纯做数学算式验证，而是按照“前端特征提取 + 后端数值解算”的思路，分别模拟 FPGA 端与 MCU 端的职责。

### 2.1 FPGA 端是如何被仿真的

FPGA 端在本课题中主要承担以下功能：

1. 对采样信号进行相关处理
2. 搜索峰值位置
3. 提取 `idxA`、`idxB`、`y1`、`y2`、`y3`
4. 按固定格式封装为 `22 Byte` 特征包

在 MATLAB 中，这部分仿真分成两种层次：

#### 1. 特征级仿真

即不从原始波形开始，而是直接构造 FPGA 最终输出的特征包。对应函数主要有：

- `build_feature_packet.m`
- `build_raw_packet.m`
- `build_feature_packet_physical.m`

这种方式适合验证：

- MCU 解算是否正确
- 插值是否有效
- 噪声作用到特征值时误差如何传播

它相当于默认 FPGA 前端已经正确工作，再重点检查后端链路。

#### 2. 原始波形级仿真

即先构造两路原始回波，再在原始波形上做局部互相关和峰值提取。对应函数主要有：

- `generate_echo_waveform_pair.m`
- `add_awgn_to_signal.m`
- `extract_feature_from_waveforms.m`

这一层更接近真实 FPGA 前端的数据流，执行顺序为：

`原始波形 -> 加噪 -> 局部互相关 -> 整数峰值 -> 三点相关值 -> 特征包`

这样就不只是验证“解算公式”，而是在 MATLAB 中验证了“从波形到特征”的前端提取过程。

### 2.2 MCU 端是如何被仿真的

MCU 端在本课题中主要承担以下功能：

1. 接收并解析特征包
2. 通过三点抛物线插值恢复亚采样修正量
3. 计算传播时间差 `dt`
4. 由 `dt` 换算流速与流量
5. 对输出结果进行异常剔除和平滑处理

在 MATLAB 中，对应函数主要有：

- `calc_dt_est_from_packet.m`
- `calc_flow_from_dt.m`
- `apply_iqr_window.m`
- `scalar_kalman_filter.m`
- `apply_noise_model_to_signal.m`

因此，这套代码本质上是在 MATLAB 环境中搭了一条“简化版 FPGA + 简化版 MCU”的联合验证链。

## 3. 如何调用

### 3.1 一键运行全部实验

```matlab
results = main_run_all;
```

适用场景：

- 一次性更新所有图和表
- 第六章初稿集中整理
- 检查整个测试框架是否仍然完整

### 3.2 单独运行某一个实验

先读入统一配置：

```matlab
cfg = sim_config();
```

然后调用单个实验，例如：

```matlab
out = exp_dt_snr_sweep(cfg);
```

或：

```matlab
out = exp_raw_waveform_pipeline(cfg);
```

适用场景：

- 只想更新某一张图
- 只想调某一个实验的参数
- 只分析某一类误差

### 3.3 单独调用底层函数

例如只想看某个流速对应的理论特征包：

```matlab
para = get_default_pipe_parameters();
feature = build_feature_packet(1.0, para);
```

只想看温度对传播时间的影响：

```matlab
para = get_default_pipe_parameters();
info = calc_physical_transit_times(1.0, para, 30);
```

只想看一段原始回波：

```matlab
cfg = sim_config();
pair = generate_echo_waveform_pair(cfg.para, cfg.echo, 1.0);
```

## 4. 文件作用说明

下面按目录说明每个 `.m` 文件的职责、典型调用方式以及它在整条仿真链中的位置。

### 4.1 根目录文件

#### `main_run_all.m`

作用：

- 整个第六章 MATLAB 测试框架的总调度入口
- 顺序运行所有实验脚本
- 汇总输出结果并写入日志

调用：

```matlab
results = main_run_all;
```

在系统中的位置：

- 相当于“实验批处理入口”

### 4.2 配置文件

#### `config/sim_config.m`

作用：

- 统一定义实验参数、输出目录、信噪比列表、滤波参数、波形参数和多变量分析参数

调用：

```matlab
cfg = sim_config();
```

在系统中的位置：

- 所有实验脚本的共享配置中心

### 4.3 基础参数与物理模型函数

#### `core/get_default_pipe_parameters.m`

作用：

- 返回默认管道参数，例如管径、壁厚、采样周期、管材类型等

调用：

```matlab
para = get_default_pipe_parameters();
```

#### `core/calc_t_wall_ns.m`

作用：

- 计算管壁传播时间修正项

调用：

```matlab
t_wall_ns = calc_t_wall_ns(para);
```

#### `core/calc_water_sound_speed_mps.m`

作用：

- 根据温度估计水中的声速

调用：

```matlab
c = calc_water_sound_speed_mps(25);
```

#### `core/calc_physical_transit_times.m`

作用：

- 根据流速、管径、角度、温度等参数计算传播时间和理论 `dt`
- 同时给出 `dt` 误差向流速误差传播的灵敏度系数

调用：

```matlab
info = calc_physical_transit_times(1.0, para, 20);
```

适用场景：

- 温度分析
- 管径敏感性分析
- `dt` 误差传播分析

### 4.4 特征包构造与解析函数

#### `core/build_feature_packet.m`

作用：

- 直接由目标流速构造特征包
- 不经过原始波形层

调用：

```matlab
feature = build_feature_packet(1.0, para);
```

在系统中的位置：

- 用于特征级 FPGA 输出仿真

#### `core/build_feature_packet_physical.m`

作用：

- 在引入温度等物理因素时，根据传播时间关系构造特征包

调用：

```matlab
feature = build_feature_packet_physical(1.0, para, 30);
```

#### `core/build_raw_packet.m`

作用：

- 将 `idxA`、`idxB`、`y1`、`y2`、`y3` 按 `22 Byte` 格式封装

调用：

```matlab
raw_packet = build_raw_packet(feature);
```

在系统中的位置：

- 相当于 FPGA 到 MCU 的接口层仿真

#### `core/calc_dt_est_from_packet.m`

作用：

- 从 `22 Byte` 特征包中解码字段
- 用抛物线插值恢复 `dt`

调用：

```matlab
est = calc_dt_est_from_packet(raw_packet, para, true);
```

第三个参数含义：

- `true`：启用抛物线插值
- `false`：仅用整数采样位置

在系统中的位置：

- 相当于 MCU 端的特征包解析与时间差解算

#### `core/calc_dt_true_from_v.m`

作用：

- 由目标流速反推理论 `dt`

调用：

```matlab
dt_info = calc_dt_true_from_v(1.0, para);
```

### 4.5 流速流量换算与统计函数

#### `core/calc_flow_from_dt.m`

作用：

- 将时间差换算为流速、体积流量、升每分钟流量等

调用：

```matlab
flow = calc_flow_from_dt(dt_ns, t1_ns, t2_ns, para);
```

在系统中的位置：

- 对应 MCU 端的流速与流量换算

#### `core/calc_metrics.m`

作用：

- 对误差数组计算 `bias`、`std`、`RMSE`、`abs_mean`、`ci95`、无效率和离群率等指标

调用：

```matlab
metrics = calc_metrics(err_vec, threshold);
```

### 4.6 噪声与滤波函数

#### `core/add_noise_to_feature.m`

作用：

- 在特征值 `y1/y2/y3` 上叠加噪声

调用：

```matlab
noisy_feature = add_noise_to_feature(feature, 20);
```

适用场景：

- 特征级鲁棒性实验

#### `core/add_awgn_to_signal.m`

作用：

- 在原始波形层叠加高斯白噪声

调用：

```matlab
noisy = add_awgn_to_signal(signal, 20);
```

适用场景：

- 原始回波可视化
- 原始波形全流程实验

#### `core/add_impulse_noise_to_signal.m`

作用：

- 在原始波形层叠加脉冲噪声
- 用于模拟偶发毛刺、突发干扰等情况

调用：

```matlab
noisy = add_impulse_noise_to_signal(signal, 20, 0.008, 6.0);
```

#### `core/add_colored_noise_to_signal.m`

作用：

- 在原始波形层叠加一阶有色噪声
- 用于模拟具有一定相关性的背景扰动

调用：

```matlab
noisy = add_colored_noise_to_signal(signal, 20, 0.92);
```

#### `core/apply_noise_model_to_signal.m`

作用：

- 按模型名称统一调度不同噪声模型
- 当前支持 `gaussian`、`impulse`、`colored`

调用：

```matlab
noisy = apply_noise_model_to_signal(signal, 20, 'gaussian', cfg.noise_model);
```

#### `core/apply_iqr_window.m`

作用：

- 执行 `IQR` 异常剔除

调用：

```matlab
out = apply_iqr_window(x, 30, 5);
```

#### `core/scalar_kalman_filter.m`

作用：

- 执行一维卡尔曼滤波递推

调用：

```matlab
out = scalar_kalman_filter(z, q, r, [], p0);
```

当前推荐配置：

- `Q = 0.1`
- `R = 0.001`
- `p0 = 15.0`

### 4.7 波形生成与特征提取函数

#### `core/generate_echo_waveform.m`

作用：

- 生成单个理想回波示意波形

调用：

```matlab
echo = generate_echo_waveform(para, cfg.echo, 1.0);
```

#### `core/generate_echo_waveform_pair.m`

作用：

- 生成两路具有真实时间差的原始回波

调用：

```matlab
pair = generate_echo_waveform_pair(para, cfg.echo, 1.0);
```

在系统中的位置：

- 用于原始波形级 FPGA 前端仿真

#### `core/extract_feature_from_waveforms.m`

作用：

- 对两路原始回波做局部互相关
- 搜索峰值位置
- 提取 `idxA`、`idxB`、`y1`、`y2`、`y3`

调用：

```matlab
feature = extract_feature_from_waveforms(sig_a, sig_b, para, 8);
```

在系统中的位置：

- 对应 FPGA 前端的相关处理与局部特征提取

### 4.8 输出辅助函数

#### `core/ensure_output_dirs.m`

作用：

- 创建输出目录

#### `core/save_experiment_figure.m`

作用：

- 统一保存 `.png` 和 `.fig`
- 避免批处理模式下图窗句柄失效

## 5. 各实验脚本的作用与调用方式

### `experiments/exp_dt_noiseless.m`

作用：

- 验证无噪声下 `dt` 解算是否准确

调用：

```matlab
cfg = sim_config();
out = exp_dt_noiseless(cfg);
```

### `experiments/exp_flow_noiseless.m`

作用：

- 验证无噪声下流速、流量换算是否准确

调用：

```matlab
cfg = sim_config();
out = exp_flow_noiseless(cfg);
```

### `experiments/exp_dt_snr_sweep.m`

作用：

- 分析不同 `SNR` 下的时间差误差和无效率

调用：

```matlab
cfg = sim_config();
out = exp_dt_snr_sweep(cfg);
```

### `experiments/exp_flow_snr_sweep.m`

作用：

- 分析不同 `SNR` 下的流速误差和流量误差

调用：

```matlab
cfg = sim_config();
out = exp_flow_snr_sweep(cfg);
```

### `experiments/exp_interp_compare.m`

作用：

- 比较整数定位与抛物线插值定位的差异

调用：

```matlab
cfg = sim_config();
out = exp_interp_compare(cfg);
```

### `experiments/exp_filter_compare.m`

作用：

- 比较原始输出、`IQR` 后输出、`IQR + Kalman` 输出

调用：

```matlab
cfg = sim_config();
out = exp_filter_compare(cfg);
```

### `experiments/exp_echo_waveform_demo.m`

作用：

- 展示理想回波与不同噪声条件下的回波波形

调用：

```matlab
cfg = sim_config();
out = exp_echo_waveform_demo(cfg);
```

### `experiments/exp_raw_waveform_pipeline.m`

作用：

- 从原始波形开始，完成“相关提取 -> 特征包 -> MCU 解算”的全流程验证

调用：

```matlab
cfg = sim_config();
out = exp_raw_waveform_pipeline(cfg);
```

### `experiments/exp_multivar_sensitivity.m`

作用：

- 研究管径、温度、噪声和 `dt` 误差传播之间的关系

调用：

```matlab
cfg = sim_config();
out = exp_multivar_sensitivity(cfg);
```

### `experiments/exp_noise_model_compare.m`

作用：

- 比较高斯噪声、脉冲噪声和有色噪声下的时间差误差与流速误差
- 用于补充“多种噪声模型”这一类进阶验证内容

调用：

```matlab
cfg = sim_config();
out = exp_noise_model_compare(cfg);
```

### `experiments/exp_monte_carlo_statistics.m`

作用：

- 在固定流速与固定信噪比条件下进行大量重复试验
- 观察误差分布、置信区间以及 `RMSE` 随试验次数的收敛情况

调用：

```matlab
cfg = sim_config();
out = exp_monte_carlo_statistics(cfg);
```

### `experiments/exp_kalman_param_sweep.m`

作用：

- 对 `Kalman` 滤波参数 `Q`、`R` 进行网格扫描
- 比较不同参数组合下的偏差、标准差与 `RMSE`
- 给出当前实验条件下更合适的推荐参数

调用：

```matlab
cfg = sim_config();
out = exp_kalman_param_sweep(cfg);
```

### `experiments/exp_kalman_step_response.m`

作用：

- 构造流速突增、突降的阶跃工况
- 观察 `Kalman` 滤波后输出是否能够及时跟随真实流速变化
- 在动态响应角度下再次比较不同 `Q/R` 参数组合

调用：

```matlab
cfg = sim_config();
out = exp_kalman_step_response(cfg);
```

## 6. 如何理解“仿真 FPGA 和 MCU 进行测试”

这套代码不是去调用真实 FPGA 比特流或真实 MCU 固件，而是在 MATLAB 中用“同等逻辑职责”来模拟二者。

### 6.1 FPGA 被如何抽象

FPGA 的真实职责是：

- 采样信号处理
- 相关峰搜索
- 特征提取
- 数据打包

MATLAB 中用以下函数实现这一抽象：

- `generate_echo_waveform_pair.m`
- `extract_feature_from_waveforms.m`
- `build_raw_packet.m`

因此可以认为：

`这几段 MATLAB 代码 == FPGA 前端处理链的可验证模型`

### 6.2 MCU 被如何抽象

MCU 的真实职责是：

- 解析特征包
- 插值恢复时间差
- 换算流速和流量
- 做输出平滑

MATLAB 中用以下函数实现这一抽象：

- `calc_dt_est_from_packet.m`
- `calc_flow_from_dt.m`
- `apply_iqr_window.m`
- `scalar_kalman_filter.m`

因此可以认为：

`这几段 MATLAB 代码 == MCU 后端算法链的可验证模型`

### 6.3 为什么这种做法有效

因为第六章要验证的不是硬件电路时序细节，而是：

1. 提取出的特征是否足够支撑后续时间差估计
2. 时间差估计是否足够支撑流速和流量计算
3. 噪声、温度、管径等因素会如何影响最终结果

因此，只要 MATLAB 中的前端特征定义、特征包格式、后端解算公式与工程实现保持一致，就能够达到验证系统方案正确性的目的。

## 7. 建议的使用方式

如果目标是“快速整理第六章图表”，建议：

1. 先运行 `main_run_all`
2. 再只对个别实验脚本做单独重复运行
3. 最后根据 `tables/` 和 `figures/` 写论文正文

如果目标是“单独研究某一问题”，建议：

- 研究插值必要性：运行 `exp_interp_compare`
- 研究噪声影响：运行 `exp_dt_snr_sweep` 与 `exp_flow_snr_sweep`
- 研究全流程：运行 `exp_raw_waveform_pipeline`
- 研究温度、管径与误差传播：运行 `exp_multivar_sensitivity`

## 8. 备注

本轮整理主要补充了：

- 更密的 `SNR` 扫频点
- 原始波形全流程验证
- 管径、温度、噪声联合敏感性分析
- `dt` 误差向流速误差的量化传播
- 三种噪声模型对比：高斯噪声、脉冲噪声、有色噪声
- 单独成图的蒙特卡洛统计实验
- `Kalman` 参数扫描实验与推荐参数配置
- `Kalman` 阶跃响应实验，用于检验流速突变时的跟随能力

后续如果第六章需要进一步增强，还可以继续补：

- 更贴近真实换能器的回波模型
- 更接近工程现场的异常工况模拟
- 板级联调实测数据与 MATLAB 曲线的对照分析

按照“必须做 / 建议做 / 进阶做”的分层来归纳，目前的完成情况可以概括为：

- 第一层：已完成  
  包括理论时间差反推特征包、MATLAB 中复现 `dt` 解算、复现流量计算、无噪声正确性验证以及高斯噪声误差分析。
- 第二层：已完成  
  已包含不同 `SNR` 下的误差曲线、不同流速点下的误差曲线、有无三点插值的对比以及有无后级滤波的对比。
- 第三层：部分完成  
  已完成完整波形级仿真、多种噪声模型、蒙特卡洛统计以及 `Kalman` 参数扫描；定点仿真与 RTL 一致性验证目前仍未纳入。
