// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Fri Feb  6 09:30:21 2026
// Host        : Tisoft running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/all_src/FPGA_project/RUF_MIX/RUF_MIX.srcs/sources_1/ip/mult_gen_0/mult_gen_0_sim_netlist.v
// Design      : mult_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_gen_0,mult_gen_v12_0_15,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_15,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module mult_gen_0
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
  mult_gen_0_mult_gen_v12_0_15 U0
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
module mult_gen_0_mult_gen_v12_0_15
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
  mult_gen_0_mult_gen_v12_0_15_viv i_mult
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
rHjAGICKtrptZDhYAdOKTqZGgRKjcxvn4FSaXjSoCtSyLql5AEAaeZtyc+vr8bzE+PtlOemzaBLC
kwrdRMX5FzBFp0Gg+2eyZVA9bz9SNYFssYNrSFYdh0clfwPadu8QUeI17H146ZfdJMskljriRjzD
z7MPaLXj/rw/TuMtAoi6X8egtwWWLhtnTaZ9bW4ahNQfFqc9cXrH98HsmSjmxxnKa6fa8Aswbo7y
MOeDdLS0mVIVQZX1ARNIo00eoC+Rzy4xozofS+293cvxawNRHP6m7lMs6vTN3+z5NZhM5vu7RB2V
Eh7G0nelfyJ9a57U6us3xTGft4MhW8iBGTBcEg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
vr5CT5VkfBygTpsjnAnnL3rmKfHoNmOY4TSs1Pusty+u/K33f7LK8xif/zmCDsa3VD/gHOH5rmYg
IaVx9ZiCarEIatGiaDu1pSMPckMaX5UTd/+4paXdytaMfybfavAX0AQLIL4jXtBX2x2ouTbOas80
YZlMQxXXaM0+a0XRJZM0y0cUVT8LXR0x1zBQzviovxJAFEdZ5GPLk91qNU11LKi76eyG1jAEdxYp
SowPeVZQscOpogg9BEBZuxJNkM7jGtQol9G7hg92mtsL7nrhC5lURtO3zIINMvQuixT9D5zkp5Qv
raoHjv9CqfB26JPrJ7knhmh+OKITQLGXJlRDgw==

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
