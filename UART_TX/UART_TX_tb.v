`timescale 1ns/10ps

module UART_TX_tb;

////////////////////////////////////////
//////////// PARAMETERS ////////////////
////////////////////////////////////////

parameter CLOCK_PERIOD    = 5 ; 
parameter TEST_CASES      = 5 ;

// parameter Parity_En_ODD   = 00;	
// parameter Parity_En_EVEN  = 01;
// parameter Parity_Disabled = 10;

////////////////////////////////////////
////////// DATA SIGNALS ////////////////
////////////////////////////////////////

reg 		   CLK_tb			   ;
reg 		   RST_n_tb	     	   ;
reg  [7:0]     P_DATA_tb	       ;
reg 		   PAR_EN_tb		   ;
reg 		   PAR_TYP_tb		   ;
reg		       DATA_VALID_tb	   ;

wire           TX_OUT_tb		   ;
wire           Busy_tb             ;


integer         i                  ;
integer         j                  ;
integer         k                  ;
integer         n                  ;
integer         m                  ;
integer         s                  ;


reg  [1:0]     Parity_Status       ;

////////////////////////////////////////
////////////// DUT /////////////////////
////////////////////////////////////////


UART_TX Dut(

.CLK        (CLK_tb)	      ,
.RST_n		(RST_n_tb)        ,
.P_DATA		(P_DATA_tb)       ,
.PAR_EN		(PAR_EN_tb)       ,
.PAR_TYP	(PAR_TYP_tb)	  ,
.DATA_VALID	(DATA_VALID_tb)   ,
.TX_OUT		(TX_OUT_tb)       ,
.Busy       (Busy_tb)
);


///////////////////////////////////////
////////////// MEMORIES ///////////////
///////////////////////////////////////

reg [7:0]  Data_seeds    [TEST_CASES-1 : 0];

reg [10:0] Expected_out_odd_parity  [TEST_CASES-1 : 0];
reg [10:0] Expected_out_even_parity  [TEST_CASES-1 : 0];
reg [10:0] Expected_out_no_parity  [TEST_CASES-1 : 0];

///////////////////////////////////////
////////// CLOCK GENERATION ///////////
///////////////////////////////////////

initial begin
CLK_tb = 0 ;
forever #(CLOCK_PERIOD/2) CLK_tb = ~ CLK_tb ;	
end

////////////////////////////////////////
/////////////// READ DATA //////////////
////////////////////////////////////////

initial begin

$readmemh("Data_h.txt",Data_seeds);
$readmemh("Expec_out_odd_parity_h.txt" ,Expected_out_odd_parity);
$readmemh("Expec_out_even_parity_h.txt",Expected_out_even_parity);
$readmemh("Expec_out_no_parity_h.txt"  ,Expected_out_no_parity);



initialize();
reset()     ;

///////// PARITY ODD ENABLED ////////////////
for(i = 0 ; i < TEST_CASES ; i = i + 1)
begin
@(negedge CLK_tb);
transmit  (Data_seeds[i],2'b00);
check_out (Expected_out_odd_parity[i],2'b00);
end

$display("-----------------------------------------------");
#(CLOCK_PERIOD);


///////// PARITY EVEN ENABLED ////////////////
for(j = 0 ; j < TEST_CASES ; j = j + 1)
begin
@(negedge CLK_tb);
transmit  (Data_seeds[j],2'b01);
check_out (Expected_out_even_parity[j],2'b01);
end	

$display("-----------------------------------------------");
#(CLOCK_PERIOD);


///////// PARITY DISABLED ////////////////////
for(k = 0 ; k < TEST_CASES ; k = k + 1)
begin
@(negedge CLK_tb);
transmit  (Data_seeds[k],2'b10);
check_out (Expected_out_no_parity[k],2'b10);
end	

$display("-----------------------------------------------");
#(3*CLOCK_PERIOD) $stop;

end

////////////////////////////////////////
///////////////// RESET ////////////////
////////////////////////////////////////

task reset;
begin
RST_n_tb = 0;
repeat(2)@(negedge CLK_tb);
RST_n_tb = 1;
end
endtask

/////////////////////////////////////////
///////////// INITIALIZATION ////////////
/////////////////////////////////////////

task initialize;
begin
P_DATA_tb     = 0;
DATA_VALID_tb = 0;
PAR_EN_tb     = 0;
PAR_TYP_tb    = 0;
end
endtask


//////////////////////////////////////////
//////////// TRANSMIT OPERATION //////////
//////////////////////////////////////////

task transmit(input [7:0] P_DATA_in , input [1:0] parity_Status_in);

begin
 case (parity_Status_in)

  2'b00: begin
		 P_DATA_tb  = P_DATA_in;
		 PAR_TYP_tb = 1        ;     // ODD PARITY
		 PAR_EN_tb  = 1'b1	  ;     // PARITY ENABLE

		  @(negedge CLK_tb) DATA_VALID_tb = 1;

		  #(CLOCK_PERIOD) DATA_VALID_tb = 0;
		 end


  2'b01: begin
  	 P_DATA_tb = P_DATA_in;
		 PAR_TYP_tb  = 1'b0   ;     // Even PARITY
		 PAR_EN_tb   = 1'b1	  ;     // PARITY ENABLE
          
         @(negedge CLK_tb) DATA_VALID_tb = 1;

		 #(CLOCK_PERIOD) DATA_VALID_tb = 0;
         end		


  2'b10: begin
  	 P_DATA_tb = P_DATA_in;
		 PAR_TYP_tb  = 1'b1   ;     // No PARITY
		 PAR_EN_tb   = 1'b0	  ;     // PARITY Disabled

		 @(negedge CLK_tb) DATA_VALID_tb = 1;

		 #(CLOCK_PERIOD) DATA_VALID_tb = 0;
         end		

endcase

end
endtask


//////////////////////////////////////////
//////////// CHECK OPERATION /////////////
//////////////////////////////////////////


task check_out(input [10:0] data_expected , input [1:0] parity_Status_in);

reg [10:0] data_collect_with_parity;
reg [9:0]  data_collect_no_parity;

begin

@(posedge CLK_tb);

case (parity_Status_in)

  2'b00: begin
		   for(n = 0 ; n < 11 ; n = n + 1)
		   begin
		     data_collect_with_parity [n] = TX_OUT_tb;
		     @(posedge CLK_tb);	
		   end

		   if(data_collect_with_parity == data_expected) $display("TEST SUCCEEDED");
		   else $display("TEST FAILED");
		 end


  2'b01: begin
  	       for(m = 0 ; m < 11 ; m = m + 1)
		   begin
		      data_collect_with_parity[m] = TX_OUT_tb;
		      @(posedge CLK_tb);	
		   end

		   if(data_collect_with_parity == data_expected) $display("TEST SUCCEEDED");
		   else $display("TEST FAILED");
         end		


  2'b10: begin
  	       for(s = 0 ; s < 10 ; s = s + 1)
		   begin
		      data_collect_no_parity[s] = TX_OUT_tb;
		      @(posedge CLK_tb);		
		   end

		   if(data_collect_no_parity == data_expected) $display("TEST SUCCEEDED");
           else $display("TEST FAILED");
         end	

  endcase
 end
endtask


endmodule