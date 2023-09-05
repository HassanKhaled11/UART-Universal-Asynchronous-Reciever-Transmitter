/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Tue Sep  5 20:32:13 2023
/////////////////////////////////////////////////////////////


module mux2X1_0 ( IN_0, IN_1, SEL, OUT );
  input IN_0, IN_1, SEL;
  output OUT;


  CLKMX2X4M U1 ( .A(IN_0), .B(IN_1), .S0(SEL), .Y(OUT) );
endmodule


module mux2X1_1 ( IN_0, IN_1, SEL, OUT );
  input IN_0, IN_1, SEL;
  output OUT;


  CLKMX2X4M U1 ( .A(IN_0), .B(IN_1), .S0(SEL), .Y(OUT) );
endmodule


module UART_TX ( SI, SE, scan_clk, scan_rst, test_mode, SO, CLK, RST_n, P_DATA, 
        PAR_EN, PAR_TYP, DATA_VALID, TX_OUT, Busy );
  input [7:0] P_DATA;
  input SI, SE, scan_clk, scan_rst, test_mode, CLK, RST_n, PAR_EN, PAR_TYP,
         DATA_VALID;
  output SO, TX_OUT, Busy;
  wire   N15, N16, N17, n55, CLK_M, RST_n_M, current_state_0_, next_state_0_,
         Counter_3_, N46, n10, n17, n18, n19, n20, n21, n23, n24, n25, n26,
         n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39, n47,
         n48, n49, n50, n51, n52, n53, n54, n59;

  AND3X2M U44 ( .A(n53), .B(n54), .C(n50), .Y(n39) );
  NAND2X3M U48 ( .A(n51), .B(n17), .Y(n24) );
  MX4XLM U50 ( .A(P_DATA[0]), .B(P_DATA[1]), .C(P_DATA[2]), .D(P_DATA[3]), 
        .S0(N15), .S1(N16), .Y(n48) );
  MX4XLM U51 ( .A(P_DATA[4]), .B(P_DATA[5]), .C(P_DATA[6]), .D(P_DATA[7]), 
        .S0(N15), .S1(N16), .Y(n47) );
  NAND2X1M U52 ( .A(N16), .B(N15), .Y(n23) );
  INVX8M U59 ( .A(n55), .Y(TX_OUT) );
  OAI21X2M U60 ( .A0(N15), .A1(n24), .B0(n20), .Y(n26) );
  MX2X2M U61 ( .A(n48), .B(n47), .S0(N17), .Y(N46) );
  AOI21X2M U62 ( .A0(n29), .A1(PAR_EN), .B0(n51), .Y(n28) );
  CLKXOR2X2M U63 ( .A(P_DATA[7]), .B(P_DATA[6]), .Y(n33) );
  XOR3XLM U64 ( .A(n30), .B(PAR_TYP), .C(n31), .Y(n29) );
  XOR3XLM U65 ( .A(P_DATA[1]), .B(P_DATA[0]), .C(n32), .Y(n31) );
  XOR3XLM U66 ( .A(P_DATA[5]), .B(P_DATA[4]), .C(n33), .Y(n30) );
  XNOR2X2M U67 ( .A(P_DATA[3]), .B(P_DATA[2]), .Y(n32) );
  NAND2X12M U68 ( .A(n10), .B(n52), .Y(Busy) );
  OAI32X2M U69 ( .A0(n23), .A1(N17), .A2(n24), .B0(n25), .B1(n54), .Y(n34) );
  AOI2B1X1M U70 ( .A1N(n24), .A0(n53), .B0(n26), .Y(n25) );
  NAND2BX2M U71 ( .AN(Busy), .B(DATA_VALID), .Y(n20) );
  OAI22X1M U72 ( .A0(n50), .A1(n20), .B0(N15), .B1(n24), .Y(n37) );
  NAND2X2M U73 ( .A(n20), .B(n21), .Y(next_state_0_) );
  NAND4X2M U74 ( .A(n17), .B(Counter_3_), .C(PAR_EN), .D(n39), .Y(n21) );
  NAND4X2M U75 ( .A(Counter_3_), .B(n50), .C(n19), .D(n53), .Y(n18) );
  NOR2X2M U76 ( .A(PAR_EN), .B(N17), .Y(n19) );
  OAI32X2M U77 ( .A0(n24), .A1(N16), .A2(n50), .B0(n49), .B1(n59), .Y(n35) );
  INVX2M U78 ( .A(n26), .Y(n49) );
  DLY1X1M U79 ( .A(n53), .Y(n59) );
  mux2X1_0 clk_mux ( .IN_0(CLK), .IN_1(scan_clk), .SEL(test_mode), .OUT(CLK_M)
         );
  mux2X1_1 rst_mux ( .IN_0(RST_n), .IN_1(scan_rst), .SEL(test_mode), .OUT(
        RST_n_M) );
  SDFFRX4M current_state_reg_1_ ( .D(n38), .SI(n52), .SE(SE), .CK(CLK_M), .RN(
        RST_n_M), .Q(SO), .QN(n10) );
  SDFFRX4M Counter_reg_0_ ( .D(n37), .SI(SI), .SE(SE), .CK(CLK_M), .RN(RST_n_M), .Q(N15), .QN(n50) );
  SDFFRX2M Counter_reg_3_ ( .D(n36), .SI(n54), .SE(SE), .CK(CLK_M), .RN(
        RST_n_M), .Q(Counter_3_), .QN(n51) );
  SDFFRX2M Counter_reg_1_ ( .D(n35), .SI(n50), .SE(SE), .CK(CLK_M), .RN(
        RST_n_M), .Q(N16), .QN(n53) );
  SDFFRX2M Counter_reg_2_ ( .D(n34), .SI(n59), .SE(SE), .CK(CLK_M), .RN(
        RST_n_M), .Q(N17), .QN(n54) );
  SDFFRX2M current_state_reg_0_ ( .D(next_state_0_), .SI(Counter_3_), .SE(SE), 
        .CK(CLK_M), .RN(RST_n_M), .Q(current_state_0_), .QN(n52) );
  NOR2X4M U43 ( .A(n10), .B(current_state_0_), .Y(n17) );
  MX2X2M U45 ( .A(n27), .B(n10), .S0(current_state_0_), .Y(n55) );
  OAI32X2M U46 ( .A0(n54), .A1(n24), .A2(n23), .B0(n51), .B1(n20), .Y(n36) );
  AOI211X2M U47 ( .A0(N46), .A1(n51), .B0(n10), .C0(n28), .Y(n27) );
  AO22XLM U49 ( .A0(n17), .A1(n18), .B0(current_state_0_), .B1(n10), .Y(n38)
         );
endmodule

