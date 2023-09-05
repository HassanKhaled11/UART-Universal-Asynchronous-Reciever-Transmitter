module UART_TX(

input 		   CLK			         ,
input 		   RST_n		         ,
input      [7:0]   P_DATA		     ,
input 		   PAR_EN		         ,
input 		   PAR_TYP		         ,
input 		   DATA_VALID	 	     ,

output reg         TX_OUT		     ,
output reg          Busy  
);



reg [2:0] current_state;
reg [2:0] next_state   ;
reg [3:0] Counter      ;
reg [7:0] p_data       ;


reg [7:0] shift_reg ;
reg shift_en ;


localparam IDLE     = 2'b00;
localparam START    = 2'b01;
localparam TRANSMIT = 2'b10;
localparam STOP     = 2'b11;


assign serial_data = (RST_n) ? shift_reg[0] : 1'b1 ;
//assign Busy        = (current_state != IDLE) ? 1'b1 : 1'b0;


always @(posedge CLK or negedge RST_n) begin
	if (!RST_n) begin
	current_state <= IDLE ;
	end

	else begin
    current_state <= next_state; 		
	end
end



always @(*)
begin

  case(current_state)

  IDLE : begin
               if(DATA_VALID && !Busy)
                begin
                  next_state   = START;
                end

                else next_state = IDLE;
         end


 START : next_state = TRANSMIT;


 TRANSMIT: begin
             if(PAR_EN) begin 
               if(Counter == 'd8) next_state = STOP;
               else next_state = TRANSMIT;
              end

              else begin
                 if (Counter == 'd8)
                 next_state = IDLE;
                 else next_state = TRANSMIT;
              end
           end


 STOP :    begin
               next_state = IDLE ;
           end

  endcase
end




always @(*)
begin

  case(current_state)

  IDLE : begin
         // Counter = 1'b0 ; 
         TX_OUT  = 1'b1 ;
         Busy    = 1'b0 ;

         if(DATA_VALID && !Busy)
              begin
                  //shift_reg  = P_DATA ;
                  p_data     = P_DATA ;
              end 
         end



 START : begin
         Busy = 1'b1;
 	     TX_OUT = 1'b0;
 	     end



 TRANSMIT: begin

               if(Counter < 'd8)
                 begin
                 shift_en = 1'b1;
                 TX_OUT = p_data[Counter] ;
                 end

               else if(PAR_EN)
                 begin
                 shift_en = 1'b0;
                 TX_OUT = (PAR_TYP)? ((^p_data)? 1'b0: 1'b1) : ((^p_data)? 1'b1 : 1'b0);
                 end

               else begin
                shift_en = 1'b0;
                TX_OUT = 1'b1; 
                end
           end



   STOP : begin
           TX_OUT     = 1'b1;
          end        


  endcase


end



always @(posedge CLK or negedge RST_n) 
begin
	if (!RST_n) begin
		shift_reg <= 0;
		Counter   <= 0;
	end

	else if(current_state == IDLE && DATA_VALID && !Busy)  shift_reg  <= P_DATA ;
	
	else if(shift_en) 
	begin
	    if(Counter < 'd8) 
	    begin
        Counter   <= Counter + 1'b1;
		//shift_reg[0] <= p_data[Counter];
        end

        else
        begin
         Counter <= 1'b0;
        end

	end


	else Counter <= 1'b0;
end

endmodule