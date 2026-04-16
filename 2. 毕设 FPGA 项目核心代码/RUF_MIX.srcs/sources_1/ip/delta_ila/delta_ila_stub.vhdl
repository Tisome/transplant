-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Fri Feb  6 09:38:43 2026
-- Host        : Tisoft running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/all_src/FPGA_project/RUF_MIX/RUF_MIX.srcs/sources_1/ip/delta_ila/delta_ila_stub.vhdl
-- Design      : delta_ila
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7s25csga225-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity delta_ila is
  Port ( 
    clk : in STD_LOGIC;
    probe0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe1 : in STD_LOGIC_VECTOR ( 49 downto 0 );
    probe2 : in STD_LOGIC_VECTOR ( 49 downto 0 );
    probe3 : in STD_LOGIC_VECTOR ( 49 downto 0 );
    probe4 : in STD_LOGIC_VECTOR ( 4 downto 0 );
    probe5 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    probe6 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe7 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe8 : in STD_LOGIC_VECTOR ( 0 to 0 );
    probe9 : in STD_LOGIC_VECTOR ( 15 downto 0 )
  );

end delta_ila;

architecture stub of delta_ila is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,probe0[0:0],probe1[49:0],probe2[49:0],probe3[49:0],probe4[4:0],probe5[15:0],probe6[0:0],probe7[0:0],probe8[0:0],probe9[15:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ila,Vivado 2019.1";
begin
end;
