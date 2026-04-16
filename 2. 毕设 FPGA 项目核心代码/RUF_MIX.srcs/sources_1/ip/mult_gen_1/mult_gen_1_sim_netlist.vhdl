-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Fri Feb  6 09:39:39 2026
-- Host        : Tisoft running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               d:/all_src/FPGA_project/RUF_MIX/RUF_MIX.srcs/sources_1/ip/mult_gen_1/mult_gen_1_sim_netlist.vhdl
-- Design      : mult_gen_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7s25csga225-1
-- --------------------------------------------------------------------------------
`protect begin_protected
`protect version = 1
`protect encrypt_agent = "XILINX"
`protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`protect key_block
KGg++J83s0yJ7o2/XMVLkRRTRjS0oC9h86tQjl1+xE1m53Uwmm0+K41skiYHo3Urr6lMQ4q2jL5Y
R/1NOu1WGg==

`protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
jCBx8aLaNWpgdwu0tsffQfmLNKET4Uy44Upxw9AlkO9Ma9Y+tqZHrHroYhGJUxa/dyJZ7Z0HDJ1t
hUhVV6SjuhVMs1NLM1MVw9F3MTSW7MB/qx7j0WAj62FJgoxsCtt6g392p1JAAosX8yACeLKiQ0KF
mnMpugzqSRDI445k7So=

`protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
zdO8kU0uCj5Mggk0oLUcYcllNQJVD7vxIj25evesPPwBvXuv6EUsbKmUaCAlFUyG0YQ0mxWxXmzV
V/dRqKxqZ1ZI8+mX4IFaTJSCcYctMZsCl+2EWvQQHakV4QzWuCyca1phNacrRJfur8Ssc/Mhbez3
GLQCRrSfyBYyi3u9J+SAJRcJapyB1syXXhclDtup6m1z2C5S+NX/ql6kVXkcd9P+C5ordunfutgU
6uco8UymF/9QFYiBCWlTkHAgd7DH3dCI1E72N2H/KpX0/0xFBk++NCVuNucOwd9h4/hAyr4L+SI0
6Dzmn6kaBO4lnMAj5P58GIeWO/EtqrPeWg4UJw==

`protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
FdbUT4bIXyyFULrG0eEn0kqX6tjVoWssNb1FURO5jvyN5IkvkkDKCSLsd4J+2RE35ttJ20+4IZm2
p3H/UGCxkuCYtlZzovVpVf93DlhFUM2iSGd/L3evdLLL8VYETZTScGFdFXqiqe4ggXPHQCSEPD+e
PmMIJTGQka0DD3H+w+9t5Po/+M8b4r1y70l3Py7aYMeCEsZ/yHRmk8szsOjUbwvFEJk8SPXrEERg
EYMIrbryPHXq5E2fCL7hTgHa+bzIdFQOc2/8wn8YMVTmIJCZLBZDXvGSSm16cifWzXKHbPSly8js
RAoD2yYva4rr9cUy8jEyEpUcPGnaJXBDnB7lsQ==

`protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
eGYl/A3vBqVYodgklvBXVlduDkQKDOe941//b/7D71XaDbW1Cqv7m5eqy+I7bUTyBfnKRV6WeTtg
K2eZlSMADPLNGmIEawb1T81kHA95L4SgxCaMDbzt0t5pO+IQTca0KxjvPFPjj860AZ/Y4IJCgD9Z
vZNfcSeez7bqGB9kVNzxh40hdeBm7XY8a+5R/yPufF2S8KSSaiPSvYwD8yXOBzVoRhqA9q5PWKTd
u6qoeWMnQ1r/hIDsge5oDE06b6+zC7odC460K8KIOtKzeCrfWezkynmD7wBR1fdIwh9FGe2Uq4lO
ZbT2QFx8Ga5NQIwIIZZci/uL4Tw/7+CPKEoddw==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`protect key_block
k1GN+kT7KgRIHJs5Cw+hQb7EZrReCsvXgXeCjz4o0RyqpPm8XlxoPCNX4kR8BSaVxBTPm8qGrOj8
IkQcLP4XpLGNjMzOE8knGvgjraCBhhY/bboSihIYbJYXuKW0k/ErxcqbMup3dsmp8N5M+ZYpiEuF
88HraBjchDshDh5xlcY=

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
jzBUDUoUQBD0tzi9B/VXNwpoyjUIKBzxkVyikkxc/QHKpaIlgud+eCQD6psG9RUWZouQN8CQmJEY
0K5qgvfm7GxXMbjLUwnVBRg4Uzfc4OTySfJMu1k9/qGISvYwf4r0rzMMp9aPgp+ElEwTGx3z9N0A
vWNdEjCI2mqdxmP3Q9AYUPTudILppELRMP4SJijczuRIhtAKpxFjTP2gL8zQE0aq1kkWRZfaHW1t
wV7tZ/jCUxkX8uj8DL6Bei6oBC1nTm/FjPhi+htKla8XNUEftaqUre2/0Sxhsxl/FTAzaex9fCj4
AMt2l6o0FpW5JlLhGnTYhWm/bgsyGCPBg6lSjQ==

`protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
iwH8YeXRdELHTKgJKQ0fkwzx5x4HpiCCcu/sfulL6LigI59ssfOhxXaNllxOxARc0YWm6i8agOUJ
aXvTpEvnAIXTGhYMQVjT8N7HMSoLLV088irWGp5hwg6Bmp2XMAEJznsjOd+ViWLdsQmpt4Fewo8Q
BW2npD9zvXbKfR8MpIKMFePw/vOIq3rAcRhT+tn6TTLQn5VrCfZ+2L774VnxHXXM2AIObH/3TfRc
odzyxsDR8lm0yhDk8BUHZmkjtbYEG3RgDtxVWknFc3bPsCJxAY0gSsUidTxvr0fSUwvk/Ks3fOxR
V7pc/RxHeMXkQvdYBS0BVJgdQTCGIS5SGRUsLg==

`protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`protect key_block
3GzFn/4dJ/jSZ38pitUAinmQi7kpo9AO7ninNdizt+ejFzJjO3pTNQ0Gfu5rvPRk+zzs78UO4lY4
fpWJjjwihFCnN88dECPPM0kpBH8MJgCxZl9x91VFWOmlViOMq/P1R5RWPCpMLQfhmGNMEui5mTts
6KssHehyP8CnZlqZIwIwhpJdEolSzoH79ragjh6mQSIp1x/o5csXfgRPk/hxlWrSAynPNuWWLIcU
oQ+NEFV/6Bid49IMnHkOSzhoQRMru61XT/EW8CHDkcomUN61C7Cagtm71PqJK3OzoNE/43t1V88g
9N4viKlLiNDnyuZjOqClONHZDPpvrgdE+7nRxA==

`protect data_method = "AES128-CBC"
`protect encoding = (enctype = "BASE64", line_length = 76, bytes = 9888)
`protect data_block
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
DdK82HZxOxsDEVK/riBbDFJ/47BwGlScRFYu
`protect end_protected
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mult_gen_1_mult_gen_v12_0_15 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 15 downto 0 );
    B : in STD_LOGIC_VECTOR ( 15 downto 0 );
    CE : in STD_LOGIC;
    SCLR : in STD_LOGIC;
    ZERO_DETECT : out STD_LOGIC_VECTOR ( 1 downto 0 );
    P : out STD_LOGIC_VECTOR ( 31 downto 0 );
    PCASC : out STD_LOGIC_VECTOR ( 47 downto 0 )
  );
  attribute C_A_TYPE : integer;
  attribute C_A_TYPE of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_A_WIDTH : integer;
  attribute C_A_WIDTH of mult_gen_1_mult_gen_v12_0_15 : entity is 16;
  attribute C_B_TYPE : integer;
  attribute C_B_TYPE of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_B_VALUE : string;
  attribute C_B_VALUE of mult_gen_1_mult_gen_v12_0_15 : entity is "10000001";
  attribute C_B_WIDTH : integer;
  attribute C_B_WIDTH of mult_gen_1_mult_gen_v12_0_15 : entity is 16;
  attribute C_CCM_IMP : integer;
  attribute C_CCM_IMP of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_CE_OVERRIDES_SCLR : integer;
  attribute C_CE_OVERRIDES_SCLR of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_HAS_CE : integer;
  attribute C_HAS_CE of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_HAS_SCLR : integer;
  attribute C_HAS_SCLR of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_HAS_ZERO_DETECT : integer;
  attribute C_HAS_ZERO_DETECT of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_LATENCY : integer;
  attribute C_LATENCY of mult_gen_1_mult_gen_v12_0_15 : entity is 1;
  attribute C_MODEL_TYPE : integer;
  attribute C_MODEL_TYPE of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_MULT_TYPE : integer;
  attribute C_MULT_TYPE of mult_gen_1_mult_gen_v12_0_15 : entity is 1;
  attribute C_OPTIMIZE_GOAL : integer;
  attribute C_OPTIMIZE_GOAL of mult_gen_1_mult_gen_v12_0_15 : entity is 1;
  attribute C_OUT_HIGH : integer;
  attribute C_OUT_HIGH of mult_gen_1_mult_gen_v12_0_15 : entity is 31;
  attribute C_OUT_LOW : integer;
  attribute C_OUT_LOW of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_ROUND_OUTPUT : integer;
  attribute C_ROUND_OUTPUT of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_ROUND_PT : integer;
  attribute C_ROUND_PT of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_VERBOSITY : integer;
  attribute C_VERBOSITY of mult_gen_1_mult_gen_v12_0_15 : entity is 0;
  attribute C_XDEVICEFAMILY : string;
  attribute C_XDEVICEFAMILY of mult_gen_1_mult_gen_v12_0_15 : entity is "spartan7";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of mult_gen_1_mult_gen_v12_0_15 : entity is "mult_gen_v12_0_15";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of mult_gen_1_mult_gen_v12_0_15 : entity is "yes";
end mult_gen_1_mult_gen_v12_0_15;

architecture STRUCTURE of mult_gen_1_mult_gen_v12_0_15 is
  signal \<const0>\ : STD_LOGIC;
  signal NLW_i_mult_PCASC_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_i_mult_ZERO_DETECT_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_A_TYPE of i_mult : label is 0;
  attribute C_A_WIDTH of i_mult : label is 16;
  attribute C_B_TYPE of i_mult : label is 0;
  attribute C_B_VALUE of i_mult : label is "10000001";
  attribute C_B_WIDTH of i_mult : label is 16;
  attribute C_CCM_IMP of i_mult : label is 0;
  attribute C_CE_OVERRIDES_SCLR of i_mult : label is 0;
  attribute C_HAS_CE of i_mult : label is 0;
  attribute C_HAS_SCLR of i_mult : label is 0;
  attribute C_HAS_ZERO_DETECT of i_mult : label is 0;
  attribute C_LATENCY of i_mult : label is 1;
  attribute C_MODEL_TYPE of i_mult : label is 0;
  attribute C_MULT_TYPE of i_mult : label is 1;
  attribute C_OPTIMIZE_GOAL of i_mult : label is 1;
  attribute C_OUT_HIGH of i_mult : label is 31;
  attribute C_OUT_LOW of i_mult : label is 0;
  attribute C_ROUND_OUTPUT of i_mult : label is 0;
  attribute C_ROUND_PT of i_mult : label is 0;
  attribute C_VERBOSITY of i_mult : label is 0;
  attribute C_XDEVICEFAMILY of i_mult : label is "spartan7";
  attribute downgradeipidentifiedwarnings of i_mult : label is "yes";
begin
  PCASC(47) <= \<const0>\;
  PCASC(46) <= \<const0>\;
  PCASC(45) <= \<const0>\;
  PCASC(44) <= \<const0>\;
  PCASC(43) <= \<const0>\;
  PCASC(42) <= \<const0>\;
  PCASC(41) <= \<const0>\;
  PCASC(40) <= \<const0>\;
  PCASC(39) <= \<const0>\;
  PCASC(38) <= \<const0>\;
  PCASC(37) <= \<const0>\;
  PCASC(36) <= \<const0>\;
  PCASC(35) <= \<const0>\;
  PCASC(34) <= \<const0>\;
  PCASC(33) <= \<const0>\;
  PCASC(32) <= \<const0>\;
  PCASC(31) <= \<const0>\;
  PCASC(30) <= \<const0>\;
  PCASC(29) <= \<const0>\;
  PCASC(28) <= \<const0>\;
  PCASC(27) <= \<const0>\;
  PCASC(26) <= \<const0>\;
  PCASC(25) <= \<const0>\;
  PCASC(24) <= \<const0>\;
  PCASC(23) <= \<const0>\;
  PCASC(22) <= \<const0>\;
  PCASC(21) <= \<const0>\;
  PCASC(20) <= \<const0>\;
  PCASC(19) <= \<const0>\;
  PCASC(18) <= \<const0>\;
  PCASC(17) <= \<const0>\;
  PCASC(16) <= \<const0>\;
  PCASC(15) <= \<const0>\;
  PCASC(14) <= \<const0>\;
  PCASC(13) <= \<const0>\;
  PCASC(12) <= \<const0>\;
  PCASC(11) <= \<const0>\;
  PCASC(10) <= \<const0>\;
  PCASC(9) <= \<const0>\;
  PCASC(8) <= \<const0>\;
  PCASC(7) <= \<const0>\;
  PCASC(6) <= \<const0>\;
  PCASC(5) <= \<const0>\;
  PCASC(4) <= \<const0>\;
  PCASC(3) <= \<const0>\;
  PCASC(2) <= \<const0>\;
  PCASC(1) <= \<const0>\;
  PCASC(0) <= \<const0>\;
  ZERO_DETECT(1) <= \<const0>\;
  ZERO_DETECT(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
i_mult: entity work.mult_gen_1_mult_gen_v12_0_15_viv
     port map (
      A(15 downto 0) => A(15 downto 0),
      B(15 downto 0) => B(15 downto 0),
      CE => '0',
      CLK => CLK,
      P(31 downto 0) => P(31 downto 0),
      PCASC(47 downto 0) => NLW_i_mult_PCASC_UNCONNECTED(47 downto 0),
      SCLR => '0',
      ZERO_DETECT(1 downto 0) => NLW_i_mult_ZERO_DETECT_UNCONNECTED(1 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity mult_gen_1 is
  port (
    CLK : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR ( 15 downto 0 );
    B : in STD_LOGIC_VECTOR ( 15 downto 0 );
    P : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of mult_gen_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of mult_gen_1 : entity is "mult_gen_1,mult_gen_v12_0_15,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of mult_gen_1 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of mult_gen_1 : entity is "mult_gen_v12_0_15,Vivado 2019.1";
end mult_gen_1;

architecture STRUCTURE of mult_gen_1 is
  signal NLW_U0_PCASC_UNCONNECTED : STD_LOGIC_VECTOR ( 47 downto 0 );
  signal NLW_U0_ZERO_DETECT_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_A_TYPE : integer;
  attribute C_A_TYPE of U0 : label is 0;
  attribute C_A_WIDTH : integer;
  attribute C_A_WIDTH of U0 : label is 16;
  attribute C_B_TYPE : integer;
  attribute C_B_TYPE of U0 : label is 0;
  attribute C_B_VALUE : string;
  attribute C_B_VALUE of U0 : label is "10000001";
  attribute C_B_WIDTH : integer;
  attribute C_B_WIDTH of U0 : label is 16;
  attribute C_CCM_IMP : integer;
  attribute C_CCM_IMP of U0 : label is 0;
  attribute C_CE_OVERRIDES_SCLR : integer;
  attribute C_CE_OVERRIDES_SCLR of U0 : label is 0;
  attribute C_HAS_CE : integer;
  attribute C_HAS_CE of U0 : label is 0;
  attribute C_HAS_SCLR : integer;
  attribute C_HAS_SCLR of U0 : label is 0;
  attribute C_HAS_ZERO_DETECT : integer;
  attribute C_HAS_ZERO_DETECT of U0 : label is 0;
  attribute C_LATENCY : integer;
  attribute C_LATENCY of U0 : label is 1;
  attribute C_MODEL_TYPE : integer;
  attribute C_MODEL_TYPE of U0 : label is 0;
  attribute C_MULT_TYPE : integer;
  attribute C_MULT_TYPE of U0 : label is 1;
  attribute C_OPTIMIZE_GOAL : integer;
  attribute C_OPTIMIZE_GOAL of U0 : label is 1;
  attribute C_OUT_HIGH : integer;
  attribute C_OUT_HIGH of U0 : label is 31;
  attribute C_OUT_LOW : integer;
  attribute C_OUT_LOW of U0 : label is 0;
  attribute C_ROUND_OUTPUT : integer;
  attribute C_ROUND_OUTPUT of U0 : label is 0;
  attribute C_ROUND_PT : integer;
  attribute C_ROUND_PT of U0 : label is 0;
  attribute C_VERBOSITY : integer;
  attribute C_VERBOSITY of U0 : label is 0;
  attribute C_XDEVICEFAMILY : string;
  attribute C_XDEVICEFAMILY of U0 : label is "spartan7";
  attribute downgradeipidentifiedwarnings of U0 : label is "yes";
  attribute x_interface_info : string;
  attribute x_interface_info of CLK : signal is "xilinx.com:signal:clock:1.0 clk_intf CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of CLK : signal is "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0";
  attribute x_interface_info of A : signal is "xilinx.com:signal:data:1.0 a_intf DATA";
  attribute x_interface_parameter of A : signal is "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef";
  attribute x_interface_info of B : signal is "xilinx.com:signal:data:1.0 b_intf DATA";
  attribute x_interface_parameter of B : signal is "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef";
  attribute x_interface_info of P : signal is "xilinx.com:signal:data:1.0 p_intf DATA";
  attribute x_interface_parameter of P : signal is "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef";
begin
U0: entity work.mult_gen_1_mult_gen_v12_0_15
     port map (
      A(15 downto 0) => A(15 downto 0),
      B(15 downto 0) => B(15 downto 0),
      CE => '1',
      CLK => CLK,
      P(31 downto 0) => P(31 downto 0),
      PCASC(47 downto 0) => NLW_U0_PCASC_UNCONNECTED(47 downto 0),
      SCLR => '0',
      ZERO_DETECT(1 downto 0) => NLW_U0_ZERO_DETECT_UNCONNECTED(1 downto 0)
    );
end STRUCTURE;
