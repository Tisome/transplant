// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sat Feb  7 00:53:03 2026
// Host        : Tisoft running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/all_src/FPGA_project/RUF_MIX/RUF_MIX.srcs/sources_1/ip/CORR_MULT/CORR_MULT_sim_netlist.v
// Design      : CORR_MULT
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7s25csga225-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "CORR_MULT,mult_gen_v12_0_15,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_15,Vivado 2019.1" *) 
(* NotValidForBitStream *)
module CORR_MULT
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
  (* C_LATENCY = "2" *) 
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
  CORR_MULT_mult_gen_v12_0_15 U0
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
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "2" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "31" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "spartan7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_15" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module CORR_MULT_mult_gen_v12_0_15
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
  (* C_LATENCY = "2" *) 
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
  CORR_MULT_mult_gen_v12_0_15_viv i_mult
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
MCkdgHuU486IE/28fC6WG7k8lwTE+6ywc9O/6mRtO3oe2JU3e9Pats4hPjYAvpx6/kyXrIyzY4VK
bstS/BZp9XRm1pAWCbtFgpxRjiptTA/dETrSijaZ/6btBDgE8Jp+ymFLkbhunKy3MwgkXTFxF/31
sL+K4FAaaMlLcmzflOGQT1QaFJuojBVJscGAJ0BuWmmVraDcIG6b7X5fvVe1pzWzSeSVMRV8qmz+
CknTmfSZIISXoi3AYBuBiUQOuMlO5Ik20GpBkVefl2iVQFKba535lhDGJxqPdBvM+qj+FCDljGAX
paeWOKYatZzpUSc9Z9gmYynd55+SmKjH7VfnmA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
VGK4MYAo23XcMkm3/n1ivmDy1DqRk9H6/QdCjbHsAS40Eljs7TW3Cyg7+spmjeCmic1jhdqLd4RX
4h+66OVpmYldbc+os2F7RPoPMPYnAWAu077zg2uWGxIeYJqckmDCFbGpqM93Q9VnmxVbMw4KWnvi
4lOMPuRAi+NCFowCLwuDVPrIsQmavy5ztxICR1xaFpyhfAXx6srIjY/7PS9c0eeXJOAau53M3KBg
hOQJvJkSvtW6VWSIg+CT+aClMpGA2fm0ev47wi8YTWjj6f1wpvQdW+1DOwvQPb7tzeZj9yOfxGXC
KoQ2j9nHJkCQCARy49vpdEa7Mh46Ja0p2mg7cw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7168)
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
