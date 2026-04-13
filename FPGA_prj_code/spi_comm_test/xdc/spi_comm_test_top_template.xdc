## Device family inferred from existing generated IP:
##   Spartan-7 xc7s25csga225-1
##
## This file is a board-level template.
## Fill PACKAGE_PIN values from your own schematic before implementation.

create_clock -name sys_clk -period 20.000 [get_ports sys_clk]

set_property IOSTANDARD LVCMOS33 [get_ports sys_clk]

set_property IOSTANDARD LVCMOS33 [get_ports {
    rst_n
    mcu_start
    fpga_int
    spi_cs_n
    spi_sclk
    spi_miso
    dbg_led[0]
    dbg_led[1]
}]

## Core board pins
set_property PACKAGE_PIN U18 [get_ports sys_clk]
set_property PACKAGE_PIN J15 [get_ports rst_n]
set_property PACKAGE_PIN K14 [get_ports mcu_start]

## MCU -> FPGA SPI
set_property PACKAGE_PIN J14 [get_ports spi_cs_n]
set_property PACKAGE_PIN N17 [get_ports spi_sclk]

## FPGA -> MCU
set_property PACKAGE_PIN U20 [get_ports spi_miso]
set_property PACKAGE_PIN N18 [get_ports fpga_int]

## Optional debug LEDs
set_property PACKAGE_PIN J18 [get_ports dbg_led[0]]
set_property PACKAGE_PIN H18 [get_ports dbg_led[1]]

set_property PULLUP true [get_ports rst_n]
set_property PULLUP true [get_ports spi_cs_n]
set_property PULLDOWN true [get_ports mcu_start]

# Test-only override: spi_sclk is an MCU-provided low-speed interface clock, not a board global clock.

set_property DRIVE 8 [get_ports {fpga_int spi_miso dbg_led[0] dbg_led[1]}]
set_property SLEW FAST [get_ports {fpga_int spi_miso dbg_led[0] dbg_led[1]}]
