module UART_TX(

input 		   CLK			         ,
input 		   RST_n		         ,
input      [7:0]   P_DATA		         ,
input 		   PAR_EN		         ,
input 		   PAR_TYP		         ,
input 		   DATA_VALID	 	         ,

output reg         TX_OUT		         ,
output             Busy

);

parameter IDLE     = 3'b000;
parameter START    = 3'b001;
parameter TRANSMIT = 3'b010;
parameter PARITY   = 3'b011;
parameter STOP     = 3'b100;


reg [2:0] current_state ;
reg [2:0] next_state    ;

integer i               ;

reg             serial_enable    ;
wire            serial_Data      ;
wire            serial_done      ;

reg             parity_enable    ;
wire            Parity_out       ;

reg    [7:0]    P_DATA_serializer;
reg    [7:0]    P_DATA_Parity    ;



serializer  ser_dut(
.CLK(CLK)                      ,
.RST_n(RST_n)                  ,
.serial_enable(serial_enable)  ,
.P_DATA(P_DATA)                ,
.Data_valid   (DATA_VALID)     ,
.serial_Data(serial_Data)      ,
.serial_done(serial_done)
);



parity_Calc par_dut(
.CLK(CLK)                     ,
.RST_n(RST_n)                 ,
.parity_enable(PAR_EN) ,
.parity_type(PAR_TYP)         ,
.P_DATA(P_DATA_Parity)        ,
.Parity_out(Parity_out)      
);




always @(posedge CLK or negedge RST_n) begin
	if (!RST_n) 
	begin
        current_state <= IDLE; 
	end
	
	else begin
	current_state <= next_state ;	
	end
end


assign Busy = (current_state != IDLE)? 1'b1 : 1'b0 ;

always@(*)
begin

P_DATA_Parity     = P_DATA;
TX_OUT          = 1    ;
serial_enable   = 0    ;

 case(current_state)
  
  IDLE    : begin
             if(DATA_VALID && !Busy)
               begin
                  P_DATA_Parity     = P_DATA;
                  next_state        = START;
               end

             else 
                begin
                  TX_OUT     = 1    ;
                  next_state = IDLE ; 
                end  
            end



  START   : begin
             TX_OUT     = 1'b0    ;
             next_state = TRANSMIT; 
            end



  TRANSMIT: begin      
               serial_enable = 1       ;
               TX_OUT = serial_Data    ;

               if(!serial_done)
               begin
               next_state = TRANSMIT   ;
               end

               else 
               begin
               serial_enable = 0                ;
                  if(PAR_EN) next_state = PARITY;
                  else next_state = STOP        ;
               end
            end



  PARITY  : begin
            TX_OUT     = Parity_out;
            next_state = STOP      ;
            end  




  STOP    : begin
            TX_OUT        = 1'b1;
            next_state    = IDLE;
            end


  default   : begin
             TX_OUT        = 1'b1;
             next_state    = IDLE;
            end
 endcase 
end


endmodule
