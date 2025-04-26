Copyright 2025 国地共建人形机器人创新中心/人形机器人（上海）有限公司, https://www.openloong.net/

# 简介

已编译实机部署包

## 更新

| 版本   | 日期      | 更新                                                                      |
| ------ | --------- | ------------------------------------------------------------------------- |
| v3.6   | 2025.4.25 | 开源版本 |
## 简介

Loong 实机框架部署包含多个业务运行组件：

1. **loong_driver** ：集成读取传感器数据、下发控制驱动任务；
2. **loong_interface** ：集成 UDP 与 DDS 通信，实现机器人交互；
3. **loong_locomotion** ：集成机器人平衡与运动控制；

为保证运行时的隔离性和稳定性，采用多进程运行。各子组件分别编译为独立的可执行程序，并通过基于无锁共享内存的数据中心（data_center）完成高效的实时数据交互。为提升研发效率，控制算法被单独编译为动态链接库，使得仿真和实机测试无需频繁修改底层架构即可快速接入，从而加速实验测试流程。

## 文件结构

### 1. 可执行文件夹 `bin`

包含各业务运行组件的可执行文件：

* `loong_driver`：执行读取传感器数据、下发控制驱动任务；
* `loong_interface`：集成 UDP 与 DDS 通信，实现机器人交互；
* `loong_locomotion`：集成机器人平衡与运动控制；

### 2. 系统配置文件夹 `config`

包含各项配置文件，具体配置请参考 `config/说明`文档。

### 3. 模型文件夹 `model`

* `onnx`：存放网络 模型文件；
* xxx `.urdf`：机器人的 URDF 文件。

### 4. 动态库文件夹 `module`

存放可执行文件所需的动态库：

* `loong_driver_sdk文件夹`：
  * libjoint_map_a64(x64).so, 关节解算动态库
  * libloong_driver_sdk_a64(x64).so, driver sdk动态库
* `nabo_locomotion文件夹`：
  * libnabo_a64.so, nabo运动控制算法动态库
  * libtvm_runtime.so, tvm强化学习运行时动态库
* `nabo_manipulation文件夹`：
  * libnabo_manipulation_a64(x64).so, nabo操作作业算法动态库

### 5. 日志文件夹 `log`

用于保存各运行组件的输出日志，具体内容请参考 log/`说明`文档。

### 6. 工具文件夹 `tools`

存放运行各业务运行组件的脚本：

* `run_driver.sh`：运行驱动任务；
* `run_interface.sh`：运行交互任务；
* `run_locomotion.sh`：运行运动控制任务；

---

## 部署流程

* 在机器人主控中建立文件夹并复制 `deployment` 库

```
mkdir xxx_ctl && cd xxx_ctl
cp -r /path/tp/directory ~/xxx_ctl
```

* 修改 `config/driver.ini` 中对应的 `SDK configuration_xx.xml`, xx代表机器人编号

```
sdkXml=configuration_xx.xml
```

* 修改 `configuration_xx.xml` 中对应机器人的零位 `CountBias`：

```
<Motor limb="0" motor="2" alias="3">
    <Polarity>-1</Polarity>
    <CountBias>3383</CountBias>
    ...
</Motor>
```

---

## 运行

所有操作均在 `tools` 文件夹内完成。运行全部脚本即可。脚本内已包含启动权限，可修改脚本中的 `password` 为本机密码以便启动。（建议使用 `terminator` 终端，支持分屏和广播功能，便于查看打印信息）

### 1. Driver 窗口

读取传感器数据并下发控制驱动，打印关节信息：

```
./run_driver.sh
```

### 2. Interface 窗口

命令通信交互，打印连接状态：

```
./run_interface.sh
```

### 3. Locomotion 窗口

运动控制器，打印当前控制状态：

```
./run_locomotion.sh
```
