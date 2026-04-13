# SPI Communication Test

This folder contains a minimal FPGA-side SPI communication test design for the MCU function `fpga_spi_read_packet()`.

## Files

- `rtl/spi_comm_test_top.v`
  - Top-level test design.
- `rtl/spi_comm_test_gen.v`
  - Waits for MCU ready level, then generates `idxA/idxB/y1/y2/y3` every 8 ms.
- `rtl/comm_spi_slave_test.v`
  - Test-only SPI slave that samples `CS/SCLK` in the FPGA system clock domain for more robust hardware bring-up.
- `create_vivado_project.tcl`
  - Creates a minimal Vivado project and adds the required sources automatically.
- `tb/spi_comm_test_top_tb.v`
  - Testbench that models the MCU reading 22 bytes in SPI mode 0.
- `xdc/spi_comm_test_top_template.xdc`
  - Board-level XDC template. `PACKAGE_PIN` values must be filled from the real schematic.

## External dependency

This test top is now self-contained and no longer depends on the main-project `comm_spi_slave.v`.
The goal is to keep the communication test isolated from the production measurement pipeline.

## Matching MCU test mode

The MCU side was switched with:

- `-1-2-Template_CN/App/inc/app_config.h`
  - `APP_MEASURE_SOURCE`

When `APP_MEASURE_SOURCE` is set to `APP_MEASURE_SOURCE_FPGA_SPI`:

- `SPI1` is initialized during hardware bring-up
- the FreeRTOS test task `task_spi_rx()` is created
- the fake-data pipeline is disabled
- `FPGA_INT` is configured as an active-high rising-edge EXTI source
- the MCU keeps `FPGA_START` high while it is ready to accept the next packet

## Packet format

- `byte0..1`  : `idxA`
- `byte2..3`  : `idxB`
- `byte4..9`  : `y1`
- `byte10..15`: `y2`
- `byte16..21`: `y3`

## Default behavior

- `fpga_int` is active high.
- SPI mode is mode 0.
- `mcu_start` is a dedicated request input from the MCU.
- Only the SPI signals required for readback are exposed at top level: `spi_cs_n`, `spi_sclk`, `spi_miso`
- The top stays idle after power-up until `mcu_start` is high.
- A new test packet becomes available every 8 ms in hardware.
- FPGA only emits a packet when both `mcu_start=1` and the next 8 ms test sample is ready.
- FPGA keeps `fpga_int` asserted until the MCU completes the SPI read.
- Test values are fixed to one valid packet:
  - `idxA=3000`, `idxB=3001`
  - `y1=955618630`, `y2=988857318`, `y3=822096006`
  - This corresponds to `dt ~= 20.52 ns`, `v ~= 1.0 m/s`, `q ~= 1.13 m^3/h` with the current MCU default parameters.
- Only two debug LEDs are used:
  - `dbg_led[0]`: mirrors `fpga_int`
  - `dbg_led[1]`: mirrors `packet_id_dbg[0]`, toggling once per completed packet

## Why this solves programming-order issues

This test project does not rely on FPGA raising `fpga_int` before the MCU is ready.

Recommended sequence:

1. Program FPGA first or MCU first, either order is acceptable.
2. Let both sides finish booting.
3. MCU drives `FPGA_START` high to indicate it is ready for the next packet.
4. FPGA waits for the next 8 ms test sample and, if `mcu_start=1`, prepares one packet.
5. FPGA raises `fpga_int`.
6. MCU receives the EXTI event, drives `FPGA_START` low, then reads the SPI packet.
7. MCU drives `FPGA_START` high again immediately after the read.

Because the packet is gated by the MCU-ready level, there is no risk of "FPGA already raised the interrupt before MCU firmware was running".

## Suggested Vivado source set

1. Add `rtl/spi_comm_test_top.v`
2. Add `rtl/spi_comm_test_gen.v`
3. Add `rtl/comm_spi_slave_test.v`
4. Set top to `spi_comm_test_top`
5. Add `xdc/spi_comm_test_top_template.xdc` and fill the real pins
6. For simulation, add `tb/spi_comm_test_top_tb.v`

## Quick start with Tcl

Inside Vivado Tcl Console:

```tcl
cd C:/Users/ZhuanZ/Desktop/transplant/FPGA_prj_code/spi_comm_test
source create_vivado_project.tcl
```

After project creation:

1. Fill the real board pins in `xdc/spi_comm_test_top_template.xdc`
2. Synthesize / implement / generate bitstream
3. Program FPGA
4. Program MCU firmware with `APP_MEASURE_SOURCE=APP_MEASURE_SOURCE_FPGA_SPI`
