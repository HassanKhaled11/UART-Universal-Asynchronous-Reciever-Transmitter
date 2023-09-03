module parity_Calc(
input          CLK			,
input          RST_n			,
input 	       parity_enable		,
input 	       parity_type  		,
input [7:0]    P_DATA			,


output 	     Parity_out      

);



assign Parity_out = (parity_enable && RST_n)? ((parity_type)? ((^P_DATA)? 1'b0: 1'b1) : (^P_DATA) ) : 1'b0;



endmodule