# 基于FPGA的超声波时差测量模块毕业论文行文架构与仿真验证方案深度研究报告

## 执行摘要

面向《基于FPGA的超声波时差测量模块》论文，给出可直接写作的章节架构与仿真验证方案。鉴于你**无法把装置装到管道上实测**，建议将验证主线明确为“物理可解释信号模型 + 噪声/流速统计模型 + 与FPGA实现一致的定点/时序计算”：在MATLAB生成带噪回波→按FPGA思路提取`idxA/idxB`与`y1/y2/y3`→抛物线插值求`dt`并换算流速/流量→对SNR、流速、采样率做蒙特卡洛统计并输出误差曲线，同时给出FPGA资源/时序/功耗估计与RTL仿真一致性证据。fileciteturn2file6fileciteturn2file15

## 论文行文架构建议

### 你给出的代码体系更适合“系统型”论文叙事

你当前工程体现出很清晰的“**FPGA前级特征提取 + MCU后级物理量解释**”分工：FPGA输出的不是最终流量值，而是`idxA/idxB + y1/y2/y3`的特征包，MCU再做采样周期换算、抛物线插值求亚采样偏移`delta`并得到`dt`，随后进入流速/流量、滤波、补偿、报警与累计等处理链。fileciteturn2file6fileciteturn2file15

因此论文最建议采用“**系统架构—关键模块—算法实现—仿真验证—讨论**”的写法，而不是只写单一算法或只写HDL模块列表。

### 对你上传的“同学论文终稿”的关键信息与可借鉴点

你上传的《本科生毕业论文终稿0402.txt》从目录和标题页来看，主题是**多模态智能座舱/情绪识别**方向，并非超声流量计/FPGA测时差方向（例如其目录含“驾驶员情绪识别”“特征标准化”“模型”等表述）。这意味着**其“技术内容”不能直接照搬**，但它的**体例结构**（中英文摘要、绪论、相关工作、方法、实验、参考文献、致谢、目录编排与页码体系等）可以作为你学校/院系格式的“模板骨架”。（若你后续再提供一份“超声/FPGA方向”的同学论文，我可以进一步做逐章对齐与“该写什么、不该写什么”的针对性映射。）

### 推荐的论文总体结构（可直接用于写作）

下述结构把“代码中已存在的模块事实”与“仿真验证闭环”强绑定，目的是让答辩时可以用**证据链**说明：即便无管道实测，仍能证明设计正确、可综合、可复现、误差可量化。

建议总字数（中文字符，含空格不含附录代码）：**2.2万–3.0万**。若你学院偏“工程实现型”，可靠“仿真设计与结果分析”把篇幅做厚；若偏“研究型”，可加强“误差机理与统计分析”。

#### 前置部分（建议2.5k–3.5k字）

- **摘要（中文）**（400–600字）  
  关键句建议：  
  1）“本文针对……提出一种基于FPGA的超声时差测量模块，实现……并通过MATLAB仿真完成验证。”  
  2）“在无法进行管道实测条件下，本文构建……噪声模型与流速模型，并采用与RTL一致的定点计算实现比特级对齐验证。”  
- **ABSTRACT（英文）**（约250–350词）  
  强调transit-time、cross-correlation、parabolic interpolation、fixed-point、FPGA/MCU co-design、Monte Carlo evaluation。  
- **符号/缩略语表（可选）**（1页）  
  `tup/tdown/dt/Ts/SNR/RMSE/BRAM/DSP/CDC`等，答辩时非常加分。

#### 正文部分（建议6章体例，适合工程型毕设）

**第一章 绪论**（2.0k–3.0k字）  
写作要点（建议按“问题→难点→方案→贡献→结构”五段式）：
- 背景：超声时差法测流的工业意义与“差分飞行时间与流量成正比”事实（用权威资料支撑）。citeturn6view1  
- 难点：`dt`量级很小、噪声/多路径导致峰值漂移；高采样率下MCU难以纯软件实时（引出FPGA）。  
- 约束条件：明确写出“无法上管道实测”，并说明论文采用“可复现仿真平台 + RTL一致性验证”替代实测。  
- 主要贡献（建议写3条，不要写太多）：  
  1）提出FPGA/MCU协同架构与特征包接口；  
  2）实现相关/互相关与峰值/插值组合的时差估计链；  
  3）建立面向SNR/流速/采样率扫描的仿真验证与统计评价体系。

**第二章 超声时差测量原理与系统需求**（3.0k–4.5k字）  
核心写法：先讲“物理”，再落到“指标需求”。
- 原理：上/下游传播时间`Tup`、`Tdown`与差分`Δt`用于求轴向速度的公式（可引用行业白皮书/说明书给出的表达）。citeturn6view0  
- 需求：  
  - 时间分辨率目标（由采样率与插值能力决定）；  
  - 数据吞吐/实时性（由4ms测量节拍、2000点采样窗口等事实引出）；fileciteturn2file1  
  - 接口需求：MCU只需读取“特征量包”，避免传输海量原始波形。fileciteturn2file6  
- 章节关键句：  
  “本课题将测量问题等价为**在噪声背景下估计两路回波的相对时延**，并以‘粗定位索引 + 局部互相关三点值’为信息压缩接口。”

**第三章 系统总体设计与硬件架构**（3.5k–5.0k字）  
建议按“三层图 + 两个接口表”来写：  
- 三层图：传感/模拟前端（可简述）→ FPGA特征提取 → MCU后处理与显示通信。  
- FPGA侧关键事实可写进论文：多时钟域（200/100/65MHz）与跨域toggle同步。fileciteturn2file0  
- MCU侧关键事实：工程存在“真实SPI链路”和“假数据链路”，仿真/联调时可用假数据保证上层闭环可跑。fileciteturn2file3  
- 接口表（建议放在本章末）：  
  1）FPGA→MCU特征包字段、字节序与触发方式；fileciteturn1file11  
  2）MCU内部数据流：输入队列→算法任务→输出快照→GUI/Modbus。fileciteturn1file1  
- 章节关键句：  
  “FPGA通过SPI从机输出固定22字节特征包，并以`fpga_int`事件通知MCU拉取，ISR只做任务唤醒，复杂读包在任务上下文进行，从而满足实时性与可维护性。”fileciteturn2file3

**第四章 FPGA测量模块设计与实现**（4.5k–6.5k字）  
写法建议：用“模块职责→时序→资源映射”组织，而不是堆HDL代码。
- 发射节拍与通道切换：4ms节拍、2ms切换、200MHz下500点burst（约2.5µs）。fileciteturn2file0fileciteturn2file8  
- 采样缓冲与跨时钟域：65MHz采样域到100MHz算法域的RAM桥接与toggle同步（建议专门一节写CDC）。fileciteturn2file0  
- 特征提取链：`algorithm`相关→`timeget`峰值索引→`corr`互相关三点值→`comm_spi_slave`组包与SPI从机输出。fileciteturn1file6fileciteturn2file2  
- 解释“为什么是三点值”：为抛物线插值提供最小充分信息，降低FPGA除法/插值复杂度。fileciteturn2file14  
- 资源估计写法（本章末给表格）：DSP/BRAM/LUT/FF四类；并说明估计方法跟综合报告一致（后文给工具链）。citeturn1search1citeturn1search4  

**第五章 时差估计算法、定点化与误差分析**（4.0k–6.0k字）  
建议按“算法链→定点链→误差链”三段。  
- 算法链：相关/互相关与最大值取时延（可引用经典时延估计方法：最大似然/广义互相关框架）。citeturn0search1  
- 插值：抛物线拟合/插值属于常用亚采样时延估计手段，文献讨论了其精度与偏差/混叠限制（可作为你做“误差随SNR/采样率变化”的理论支点）。citeturn6view2  
- 定点链：  
  - 建议明确：哪几个量用定点（ADC样本、相关累加、`y1/y2/y3`、`delta`、`dt`），如何选择字长与溢出策略；  
  - 在MATLAB中用定点对象固化“舍入/饱和/溢出”规则，保证与硬件一致（见后续仿真方案）。citeturn1search3  
- 误差链：至少写清四类误差源并给公式/上界：  
  1）采样量化误差（ADC位宽）；  
  2）时间量化误差（`Ts`与插值）；  
  3）相关峰值抖动（噪声、带限导致相关主瓣变宽）；  
  4）定点溢出与截断误差（累加增长、乘法位宽）。  
- 一定要把“代码事实”写进去：MCU侧计算`Ts = 1e9/65e6`并做`dt = (t2 - t1) + delta * Ts`。fileciteturn2file15

**第六章 MATLAB仿真平台与验证方案**（5.0k–8.0k字）  
本章是你弥补“无实测”的核心章节：必须写得最扎实（模型、参数、流程、统计、复现）。  

**第七章 结果分析、对比与讨论**（3.5k–5.5k字）  
- 图：误差曲线（随SNR/流速/采样率变化）；直方图/箱线图；相关峰形示意。  
- 表：资源/时序/功耗估计；不同噪声模型下稳健性对比。  
- 讨论：说明误差机理、失败案例（如低SNR时假峰）、以及与理论/文献规律的一致性。citeturn6view2  

**第八章 总结与展望**（1.2k–2.0k字）  
- 总结：按“架构、算法、验证”三条归纳，不要泛泛。  
- 展望：列出“未来上管道实测、温度补偿、多路径建模、硬件在环、功耗优化”等可落地扩展。

---

## 系统设计与硬件架构

### 体系结构可以直接写成“端到端数据流”

你工程最强的论文表达点是“端到端数据流闭环”，建议用一张总图（FPGA→MCU→GUI/Modbus）贯穿全文，并在文字中把关键事实钉死：

- FPGA以**4ms测量节拍**组织发射/采样，通道在周期中点切换，保证相邻测量帧为A/B两路交替。fileciteturn2file0  
- 200MHz发射域输出**500点burst**（约2.5µs），burst结束通过`ad_tog`翻转触发采样启动，适合跨时钟域同步。fileciteturn2file8  
- FPGA完成从ADC流到特征包的全变换，并通过SPI从机方式提供给MCU读取。fileciteturn1file6fileciteturn2file2  
- 包格式固定**22字节/176bit**：`idxA(16)+idxB(16)+y1(48)+y2(48)+y3(48)`，无Header、无CRC；事件信号`fpga_int`提示MCU拉包。fileciteturn1file11  

这些事实写清楚后，你后续的MATLAB仿真就可以严格对齐：仿真输出同样的22字节包，再走同样的MCU算法链（或其等价MATLAB实现）。

### 模块划分建议（论文表达与工程实现两用）

建议在论文“FPGA模块划分”小节用“控制链 + 数据链 + 接口链”三类来讲，而不要按文件名堆砌：

- 控制链：节拍/通道切换/采样触发（`pwm`与`ad_tog`，以及跨域同步）。fileciteturn2file0  
- 数据链：采样RAM→相关→峰值→互相关三点。fileciteturn2file2  
- 接口链：组包、SPI从机、读包完成跨域清除。fileciteturn1file11  

在MCU侧同样分三类写：
- 中断与任务协同（`fpga_int`触发EXTI，ISR只通知任务）。fileciteturn2file3  
- 输入源可替换：真实`task_spi_rx`或假数据`task_fake_data`。fileciteturn1file1  
- 算法消费与输出：`task_algorithm`阻塞取包→解包与`dt`计算→更新`g_algo_out`供GUI/Modbus读取。fileciteturn2file4  

### 接口时序与吞吐量写法（建议用“预算表”）

你可以在论文中给一个“时序预算表”，把每个阶段的时间量级写出来，帮助评委直观理解实时性：

- 发射burst：约2.5µs（200MHz×500点）。fileciteturn2file8  
- ADC采样窗口：若采样2000点、采样率65MHz，则窗口约30.8µs（建议在文中给出计算式；采样率来自你工程时钟规划）。fileciteturn2file0  
- 测量节拍：4ms周期（意味着你有充足余量做相关/互相关计算与SPI传输）。fileciteturn2file0  
- SPI传输：22字节本身很短，关键是中断唤醒与任务读包机制（你代码已按“中断轻量化”组织）。fileciteturn2file3  

### 资源估计写法（在“未指定FPGA型号”前提下的可用方案）

你尚未给出FPGA型号（**未指定**），建议论文中显式列“可选范围”并说明估计方法：

- 器件家族可选：低成本如entity["company","Xilinx","fpga vendor"] 7-series/Spartan-7/Artix-7 或 entity["company","Intel","semiconductor company"] Cyclone系列（仅作为举例，实际以你选型为准）。citeturn1search4  
- 估计方法：  
  - 乘加结构优先推断到DSP块（Vivado/Quartus均有推断规则可引用）。citeturn1search9  
  - RAM优先推断到Block RAM；CDC用toggle同步降低亚稳风险。fileciteturn2file0  
- 在论文中建议承诺“最终资源与时序以综合/实现报告为准”，并在结果章贴出综合摘要表（LUT/FF/BRAM/DSP、Fmax、时序裕量）。

---

## 算法与信号处理流程

### 物理原理到数学量：必须把`tup/tdown/dt`写成可验证链条

超声时差法的共同表述是：顺流与逆流传播时间不同，其差分与流速相关。行业资料给出了常见的速度表达式，例如白皮书中给出轴向速度与`Δt`、声程长度`L`、夹角`θ`及`Tup/Tdown`的关系式。citeturn6view0  
同时，传感器成对工作、零流时`t1≈t2`、有流时出现`(t2-t1)`并与流速成比例的描述，也可由工业厂商的原理说明支撑。citeturn6view1  

**论文写作建议**：把“物理量→可测量量→可计算量”写成三步：
1) 可测量量：两路回波的相对到达时间差；  
2) 可计算量：相关峰索引`idxA/idxB`与局部互相关`y1/y2/y3`；fileciteturn1file11  
3) 可解释量：`dt`→流速→流量（跨越几何参数、单位、补偿等）。

image_group{"layout":"carousel","aspect_ratio":"16:9","query":["transit time ultrasonic flow meter diagram upstream downstream","clamp-on ultrasonic flowmeter acoustic path angle diagram","ultrasonic flowmeter time-of-flight principle illustration"],"num_per_query":1}

### 时差测量算法链：与你工程一致的“粗定位+细插值”表述

你工程的接口设计本质上已经把“粗定位”和“细定位”分解为两类特征：
- `idxA/idxB`：粗时间峰值索引；  
- `y1/y2/y3`：互相关在`-1/0/+1`附近的三点值，用于抛物线插值获得亚采样偏移`delta`。fileciteturn2file14  

MCU侧按照采样周期`Ts`将索引转为时间，并用抛物线插值得到更精细的`dt`计算式（你文档已明确：`dt = (t2 - t1) + delta * Ts`，且`Ts = 1e9/65e6`）。fileciteturn2file15  

**论文关键句建议**：  
“本文采用‘相关峰值粗定位 + 互相关三点抛物线插值’的组合估计策略：粗定位保证抗噪稳健与搜索范围收敛，抛物线插值提供亚采样分辨率并显著降低FPGA端除法/插值硬件复杂度。”

### 滤波、定时与采样率：建议写成“为何这样选”的工程解释

- 定时：4ms节拍足够覆盖burst、采样与计算，且留有裕量用于接口与后处理。fileciteturn2file0  
- 滤波/后处理：MCU算法链包含SQ窗口统计、滑动窗口、卡尔曼滤波、零漂补偿、限幅和报警等步骤，可在论文中作为“测量稳定化”章节重点阐释。fileciteturn2file13  
- 采样率：实验维度必须包含“采样率变化对误差的影响”，因为抛物线插值对相关函数的离散化密度敏感；相关文献也讨论了低过采样时插值偏差与混叠限制，可作为理论解释依据。citeturn6view2  

### 量化误差分析：建议至少给出可落地的四个结论

在论文中建议把量化误差拆成四类并给出“结论句”（便于评阅打分）：

1) **时间量化下界**：不插值时`dt`分辨率≈`Ts`；插值后可达`α·Ts`（α由SNR与相关峰曲率决定）。  
2) **ADC量化误差影响路径**：量化噪声→相关输出噪声→峰值抖动→`dt`方差上升。  
3) **定点截断/溢出风险**：互相关是乘加累加，累加位宽不足会出现饱和或回绕，导致`y1/y2/y3`畸变，从而直接污染`delta`。  
4) **工程约束与验证方式**：所有定点策略必须用MATLAB“定点对象+与RTL一致的舍入/饱和规则”做比特级对齐验证。citeturn1search3  

---

## MATLAB仿真验证方案

### 总体目标：把“无实测”转化为“可复现的证据链”

你论文的验证必须同时回答三个问题：
- 物理模型上：在可解释的传播模型下，`dt`与流速的关系是否正确（趋势与量级）；citeturn6view0  
- 算法上：相关+插值在噪声下是否稳健（误差随SNR/采样率/流速变化）；citeturn6view2  
- 实现上：MATLAB计算与FPGA/MCU实现是否一致（至少做到“数值闭环一致”，最好做到“比特级一致”）。fileciteturn2file15  

### 未指定参数清单与建议范围

下表用于满足“参数未指定要列明”的要求；写作时建议放在“仿真平台参数”小节开头，后续所有图表都引用该表的符号。

| 参数 | 当前状态 | 建议范围（用于论文扫描） | 备注 |
|---|---|---|---|
| FPGA型号/系列 | 未指定 | 入门FPGA即可（含足够DSP与BRAM） | 综合报告最终决定 |
| ADC位宽 | 未指定 | 10–16 bit | 影响量化噪声 |
| 采样率`fs` | 工程中出现65MHz | 5–100 MHz（至少覆盖`fs/f0`=2,4,8） | 时钟规划含65MHz采样域fileciteturn2file0 |
| 发射中心频率`f0` | 未指定 | 0.5–4 MHz（液体常见） | 与换能器相关 |
| burst长度 | 工程中500点@200MHz | 1–10 µs等量级 | 500点约2.5µsfileciteturn2file8 |
| 声程长度`L` | 未指定 | 0.05–0.5 m | 由安装方式决定 |
| 夹角`θ` | 未指定 | 30°–60° | 影响灵敏度(∝cosθ)citeturn6view0 |
| 介质声速`c` | 未指定 | 水约1450–1550 m/s（可做温度扫描） | 可在未来工作做温度补偿 |
| 流速范围`v` | 未指定 | 0–5 m/s（可扩到10 m/s） | 与应用场景相关 |
| 测量节拍 | 工程中4ms | 1–20 ms | 4ms来自`pwm`节拍fileciteturn2file0 |


### 仿真流程与数据格式

建议把仿真平台拆成三层，便于“复现”和“对齐RTL”：

- **层A：物理回波生成器**（可解释）  
  输入：`v(t)`、`c`、`L`、`θ`、`f0`、burst波形；输出：上/下游离散回波序列`xA[n]`、`xB[n]`（含衰减/多径可选）。  
- **层B：FPGA等价特征提取器**（等价实现）  
  输入：`xA[n]`、`xB[n]`；输出：`idxA/idxB/y1/y2/y3`，且打包为22字节，与工程一致。fileciteturn1file11  
- **层C：MCU等价后处理器**（一致实现）  
  输入：22字节包；输出：`t1/t2/dt + 流速/流量/SQ`，与工程算法链一致。fileciteturn2file15  

**输入/输出数据格式建议**（兼顾MATLAB与RTL仿真）：
- `adc_frame_A.mem`、`adc_frame_B.mem`：每行一个采样点的十六进制（推荐补齐到16bit有符号）。  
- `expected_packet.bin`：22字节二进制（大端字段），用于RTL testbench自检。fileciteturn2file15  
- `result.csv`：每行一个试验（含seed、SNR、fs、v、dt_true、dt_hat、v_hat、SQ等），用于统计与画图。

### 仿真步骤流程图（mermaid）

```mermaid
flowchart TD
    A[参数与场景配置<br/>fs,f0,L,θ,c,v(t),噪声类型与强度,Monte Carlo次数] --> B[生成发射burst与通道时序<br/>与4ms节拍对齐]
    B --> C[物理回波模型<br/>tup/tdown或等价dt生成 + 衰减/带宽/多径(可选)]
    C --> D[加噪/抖动/量化<br/>AWGN/有色/脉冲/时钟抖动 + ADC位宽量化]
    D --> E[FPGA等价特征提取<br/>相关/峰值idxA idxB + 互相关y1 y2 y3]
    E --> F[组包(22字节)并存档<br/>与SPI字段一致]
    F --> G[MCU等价后处理<br/>Ts换算 + 抛物线插值delta + dt + 流速/流量滤波]
    G --> H[评价指标计算<br/>RMSE/Bias/MAPE/离群率/置信区间]
    H --> I[参数扫描与对比作图<br/>误差-SNR/流速/采样率曲线 + 统计表]
    I --> J[输出论文图表与复现材料<br/>脚本/数据/种子/版本号]
```

（建议在论文中注明：E与G两步分别对齐工程中的“FPGA特征提取包”和“MCU计算`dt`与流量输出”的实现逻辑。fileciteturn2file6fileciteturn2file15）

### 重复试验与统计方法（写进论文的“可复现条款”）

建议至少采用以下统计规范（评委会认为更“像研究”）：

- 每个参数点（例如SNR=20 dB、fs=65MHz、v=1 m/s）做**N=200–1000次**蒙特卡洛；并固定伪随机种子记录在CSV。  
- 报告：均值Bias、标准差STD、RMSE、95%置信区间（均值的CI可用`t`分布或bootstrap）。  
- 离群率：给出阈值（如`|e_v|>3σ`或`|e_v|>x%FS`）并报告比例；离群样本要展示“相关峰形”示例图解释原因。citeturn6view2  

---

## FPGA实现细节与验证策略

### 代码组织与数据流（建议写成“可审计”的工程结构）

建议你论文在“工程实现”章节给出一个“目录—职责”表（不用贴全部文件），并强调：
- `RUF.v`路径为当前主链、`Top.v`更像历史验证顶层；`corr.v`为主实现，`DeltaT.v`可作为备选/历史说明。fileciteturn2file5  
- `comm_spi_slave`为正式通信实现：SPI Mode 0 从机、读完176bit后清包的跨域toggle机制。fileciteturn1file11  

### 测试向量与RTL仿真策略（“无实测”情况下最关键的工程证据）

建议你把验证分成三层，每层都能形成论文里的“证据图/证据表”：

1) **模块级自检TB**  
   - `pwm`：检查4ms节拍、2ms切换、burst长度、`ad_tog`翻转。fileciteturn2file0  
   - `comm_spi_slave`：检查字段打包字节序、`fpga_int`时序、读完清包。fileciteturn1file11  
2) **链路级一致性仿真（FPGA输入波形→输出包）**  
   - 用MATLAB生成`adc_frame_A/B.mem`，TB用`$readmemh`喂给ADC接口或直接喂给缓冲模块；  
   - TB导出MISO串流并重组22字节包；  
   - 与MATLAB“FPGA等价特征提取器”的输出做逐字节比对（通过即为**比特级一致**）。  
3) **系统级闭环（包→MCU算法→流量）**  
   - 复用你的工程事实：MCU侧本来就支持“假数据链路”产生与真实包一致的输入，从而让GUI/Modbus/参数系统闭环跑起来。fileciteturn2file3  
   - 你可以在PC端用同一套解包与`dt`计算逻辑做对照（或在MATLAB中复现`rufx_calc_t1_t2_dt`）。fileciteturn2file15  

### 综合、时序与功耗估计（写作时如何引用官方工具链）

在“工具链与评估方法”小节中，建议明确写出两套路径（取决于你最终选型）：

- entity["company","AMD","semiconductor company"] 系列FPGA：建议引用UG901对综合/推断DSP的说明，并指明`USE_DSP`等综合选项如何影响乘加映射。citeturn1search1citeturn1search9  
  DSP块结构可引用UG479作为DSP48E1能力依据（用于解释“为何乘加适合进DSP块”）。citeturn1search4  
- entity["company","Intel","semiconductor company"] 系列FPGA：功耗估计可引用Quartus Power Analyzer关于toggle rate/仿真向量驱动功耗估计的说明，并说明你将采用“默认toggle vs 向量驱动”两级估计。citeturn1search2  

**论文中功耗/资源建议写法**：  
- 资源：给“综合后资源表”（LUT/FF/BRAM/DSP）+“关键模块资源占比”。  
- 时序：给目标时钟（100MHz算法域、65MHz采样域、200MHz发射域）与实现后Fmax/裕量。fileciteturn2file0  
- 功耗：给静态/动态功耗估计，并说明使用了哪些toggle来源（默认或VCD/SAIF）。

---

## 结果展示、实验局限性与未来工作

### 结果展示必须包含的曲线与表格（对应你要求的三维扫描）

你明确要求“误差随SNR/流速/采样率变化的曲线”，建议最低配图组如下（每张图都要写清固定了哪些参数）：

- 图A：`dt RMSE` vs SNR（固定`v`与`fs`）  
- 图B：流速相对误差（MAPE或NRMSE）vs SNR（固定`v`与`fs`）  
- 图C：`dt RMSE` vs 流速（多条曲线对应不同SNR；固定`fs`）  
- 图D：流速误差 vs 采样率（多条曲线对应不同SNR或不同噪声模型；固定`v`）  
- 图E：离群率 vs SNR（对比AWGN/有色/脉冲噪声）  
- 图F（示例图）：典型相关函数与插值示意（高SNR vs 低SNR各一幅），解释假峰与峰锁定。

资源/时序/功耗建议至少两张表：
- 表1：综合资源与时序摘要（含目标频率、Fmax、裕量，LUT/FF/BRAM/DSP）。citeturn1search1  
- 表2：不同噪声模型下（AWGN/有色/脉冲）的误差统计对比（Bias/STD/RMSE/离群率）。

### 实验局限性写法（要诚实，但要“可辩护”）

你无法上管道实测，这不是致命问题，但必须把局限写成“已知差距+未来补齐路径”：

- 局限一：回波模型的真实性受限（真实管道存在换能器耦合、壁厚不均、流型变化、多径更复杂）。  
- 局限二：仿真假设的噪声模型可能与真实现场不同（因此你用多噪声模型扫描以覆盖不确定性）。  
- 局限三：缺少标定与溯源（真实系统常需要多点标定；你可引用工业资料说明标定是工程常态，并把它放入未来工作）。citeturn0search4  

### 未来工作建议（要落到“下一步做什么”）

建议把未来工作分成“工程验证补齐”和“算法/实现优化”两类，每类3条以内：

- 工程验证补齐：  
  1）搭建小型回路/对比标定（哪怕只是实验台，不一定上工程管道）；  
  2）温度/声速补偿与参数标定；  
  3）硬件在环：MATLAB生成波形→DAC/信号源注入→FPGA/MCU实物链路跑通。  
- 算法/实现优化：  
  1）更稳健的互相关预处理（带通/匹配滤波、GCC类方法）；citeturn0search1  
  2）插值改进（提高低过采样下精度，或减小偏差）；citeturn6view2  
  3）加入包校验（Header/CRC）与异常检测，提高接口鲁棒性（当前包无CRC是可讨论点）。fileciteturn1file11  

---

## 参考资料与优先检索来源

### 优先级最高的资料（建议你论文引用顺序也按此）

- FPGA厂商官方文档  
  - entity["company","Xilinx","fpga vendor"]/entity["company","AMD","semiconductor company"]：Vivado综合与DSP推断（UG901、`USE_DSP`），DSP48E1结构（UG479）。citeturn1search1citeturn1search9citeturn1search4  
  - entity["company","Intel","semiconductor company"]：Quartus Power Analyzer/功耗估计指南（toggle rate与向量驱动）。citeturn1search2  
- 超声流速测量原理与工程解释  
  - entity["company","Sierra Instruments","flow meter manufacturer"] 白皮书给出`Δt`与速度关系式，并解释数字相关测时差思路。citeturn6view0  
  - entity["company","Endress+Hauser","instrumentation company"] 学习中心对时差法（time-of-flight）原理、传感器成对工作与`(t2-t1)`含义有清晰解释。citeturn6view1  
- 时延估计与插值文献（为“误差机理”提供理论背书）  
  - 广义互相关/最大似然时延估计经典论文摘要可支持“相关峰最大值即为时延估计”的框架表述。citeturn0search1  
  - 抛物线插值在互相关时延估计中的精度/偏差与过采样关系讨论，可用于解释你做“采样率扫描”的必要性。citeturn6view2  
- MATLAB/Simulink与定点工具链  
  - entity["company","MathWorks","matlab vendor"]：`awgn()`（AWGN噪声注入）、定点`fimath`的舍入/溢出模式（保证与硬件一致）。citeturn0search3citeturn1search3  
- 你提供的工程仓库与内部分析文档（作为“实现事实”引用）  
  - `Tisome/-1-2-Template_CN`仓库目录结构与`doc/`中的分析文档可作为你论文“实现依据”。citeturn3view0citeturn4view0  
  - 关键实现事实（22字节包、时钟域、4ms节拍、MCU `dt`计算式等）已在你上传的分析文档中明确，可直接转写进论文。fileciteturn1file11fileciteturn2file0fileciteturn2file15  

### MCU平台资料（用于论文“硬件平台说明”）

若你需要在论文中交代MCU平台（例如GD32F30x/GD32F303），建议引用entity["company","GigaDevice","gd32 mcu vendor"]的用户手册/数据手册与产品页，说明其Cortex‑M4、主频、片上资源与外设能力。citeturn2search7citeturn2search1  

### 关于“任务通知/中断轻量化”的写作来源（可选但加分）

你工程的“ISR只通知任务、复杂处理在任务上下文完成”符合RTOS实践，若论文需要引用规范，可引用FreeRTOS对`vTaskNotifyGiveFromISR`的官方API说明。citeturn2search17