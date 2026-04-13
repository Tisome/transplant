// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Fri Feb  6 09:39:39 2026
// Host        : Tisoft running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/all_src/FPGA_project/RUF_MIX/RUF_MIX.srcs/sources_1/ip/mult_gen_1/mult_gen_1_sim_netlist.v
// Design      : mult_gen_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_1,mult_gen_v12_0_15,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_15,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module mult_gen_1
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [15:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [15:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [31:0]P;

  wire [15:0]A;
  wire [15:0]B;
  wire CLK;
  wire [31:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "16" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "16" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "31" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_1_mult_gen_v12_0_15 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "16" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "16" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "31" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "spartan7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_15" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_gen_1_mult_gen_v12_0_15
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [15:0]A;
  input [15:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [31:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [15:0]A;
  wire [15:0]B;
  wire CLK;
  wire [31:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "16" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "16" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "31" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "spartan7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_gen_1_mult_gen_v12_0_15_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
KGg++J83s0yJ7o2/XMVLkRRTRjS0oC9h86tQjl1+xE1m53Uwmm0+K41skiYHo3Urr6lMQ4q2jL5Y
R/1NOu1WGg==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jCBx8aLaNWpgdwu0tsffQfmLNKET4Uy44Upxw9AlkO9Ma9Y+tqZHrHroYhGJUxa/dyJZ7Z0HDJ1t
hUhVV6SjuhVMs1NLM1MVw9F3MTSW7MB/qx7j0WAj62FJgoxsCtt6g392p1JAAosX8yACeLKiQ0KF
mnMpugzqSRDI445k7So=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zdO8kU0uCj5Mggk0oLUcYcllNQJVD7vxIj25evesPPwBvXuv6EUsbKmUaCAlFUyG0YQ0mxWxXmzV
V/dRqKxqZ1ZI8+mX4IFaTJSCcYctMZsCl+2EWvQQHakV4QzWuCyca1phNacrRJfur8Ssc/Mhbez3
GLQCRrSfyBYyi3u9J+SAJRcJapyB1syXXhclDtup6m1z2C5S+NX/ql6kVXkcd9P+C5ordunfutgU
6uco8UymF/9QFYiBCWlTkHAgd7DH3dCI1E72N2H/KpX0/0xFBk++NCVuNucOwd9h4/hAyr4L+SI0
6Dzmn6kaBO4lnMAj5P58GIeWO/EtqrPeWg4UJw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
FdbUT4bIXyyFULrG0eEn0kqX6tjVoWssNb1FURO5jvyN5IkvkkDKCSLsd4J+2RE35ttJ20+4IZm2
p3H/UGCxkuCYtlZzovVpVf93DlhFUM2iSGd/L3evdLLL8VYETZTScGFdFXqiqe4ggXPHQCSEPD+e
PmMIJTGQka0DD3H+w+9t5Po/+M8b4r1y70l3Py7aYMeCEsZ/yHRmk8szsOjUbwvFEJk8SPXrEERg
EYMIrbryPHXq5E2fCL7hTgHa+bzIdFQOc2/8wn8YMVTmIJCZLBZDXvGSSm16cifWzXKHbPSly8js
RAoD2yYva4rr9cUy8jEyEpUcPGnaJXBDnB7lsQ==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
eGYl/A3vBqVYodgklvBXVlduDkQKDOe941//b/7D71XaDbW1Cqv7m5eqy+I7bUTyBfnKRV6WeTtg
K2eZlSMADPLNGmIEawb1T81kHA95L4SgxCaMDbzt0t5pO+IQTca0KxjvPFPjj860AZ/Y4IJCgD9Z
vZNfcSeez7bqGB9kVNzxh40hdeBm7XY8a+5R/yPufF2S8KSSaiPSvYwD8yXOBzVoRhqA9q5PWKTd
u6qoeWMnQ1r/hIDsge5oDE06b6+zC7odC460K8KIOtKzeCrfWezkynmD7wBR1fdIwh9FGe2Uq4lO
ZbT2QFx8Ga5NQIwIIZZci/uL4Tw/7+CPKEoddw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
k1GN+kT7KgRIHJs5Cw+hQb7EZrReCsvXgXeCjz4o0RyqpPm8XlxoPCNX4kR8BSaVxBTPm8qGrOj8
IkQcLP4XpLGNjMzOE8knGvgjraCBhhY/bboSihIYbJYXuKW0k/ErxcqbMup3dsmp8N5M+ZYpiEuF
88HraBjchDshDh5xlcY=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
jzBUDUoUQBD0tzi9B/VXNwpoyjUIKBzxkVyikkxc/QHKpaIlgud+eCQD6psG9RUWZouQN8CQmJEY
0K5qgvfm7GxXMbjLUwnVBRg4Uzfc4OTySfJMu1k9/qGISvYwf4r0rzMMp9aPgp+ElEwTGx3z9N0A
vWNdEjCI2mqdxmP3Q9AYUPTudILppELRMP4SJijczuRIhtAKpxFjTP2gL8zQE0aq1kkWRZfaHW1t
wV7tZ/jCUxkX8uj8DL6Bei6oBC1nTm/FjPhi+htKla8XNUEftaqUre2/0Sxhsxl/FTAzaex9fCj4
AMt2l6o0FpW5JlLhGnTYhWm/bgsyGCPBg6lSjQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NmCtfVptzf74YTIO8mP+VK787L2zlxW7La6MiQkhEzo4lmLb7vlZp1iJwhq/6qDNnnP1BZed5DQr
YG041qEoNxlIyIZ1pApeaiJHyk4f52dCrzMiyPXegH8mrG7EMxHTBZSk2tvCQAwtqNakIicqvrr3
I7ou3212fHnrCb6yCILdhGmJCdzGMxsR7HcuQs0V00bdvbbHwxmCs3wnI+DBCH5e4tXFneO3eTFK
CADaZtkqzEYVAfCV/VnXMbtLfutwHuoWfy6kvbX1RU4nB5u1i746MuJuC9gRF31F5OwfxDQe3rFk
nJKs7xH6Uh3+xyuxd00PLvkQSQXv8o9y0qxmKg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
f8OTma0Ol5MQ1o0mrotfNyjb0pFaxdw6UJz+JzUEnSGdMzATilem+Vu0bGZi3c6qhRZmGIhoRazc
bYdo642GX7Dpo6A+rB2tK2GE50O1BCwbmWtQYLWZUypKDfsF6gpFaQm0SzENdWt1nZytH9tbebsZ
G8/kYW3CwCryLn/1ezAW5fz4lGeD+lTKxMEwdF5GxJoIDDi67ouAwdQbE1YAWYznuoi1BDS6bFPv
Pu1X2NZyB14KZPt/FzRPBuRXObFIJlfKuQtrWtr34VddWiM5oMhWqCskZC/ab4Bj7sH3bmgumDqP
FRcieZRYb6XVjYQGkLp38APLwz38RE5dqzjPYw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7232)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
