# timeget模块设计文档

模块设计目标

本模块实现在卷积后的1851个数据中找到最大值并输出其索引

逻辑分析

该模块设计较为简单，其执行逻辑如下

## 1. 最初先把curr_max赋值为MIN_VAL（ACCW位数下有符号数的最小值），将curr_idx赋值为0。

## 2. 当接收到数据且seen_any为高时，将接收到的数据data_in和当前的curr_data进行比较，保存较大值的数值和索引到curr_max和curr_idx中。

3. 当接受到frame_end帧结束信号时，将curr_max和curr_idx分别赋值给max_out和max_idx，拉高max_valid数据有效信号，同时将其他中间变量信号归零重置。
