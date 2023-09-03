module serializer(
input               CLK		               ,
input               RST_n                ,
input 		        serial_enable          ,
input    [7:0]      P_DATA               ,
input               Data_valid           ,

output              serial_Data          ,
output              serial_done

);

reg      load_flag          ;
reg [3:0] counter           ;
reg [7:0] shift_reg         ;


assign serial_Data = shift_reg[0];
assign serial_done = (counter == 4'd7) ? 1'b1 : 1'b0 ;


always @(posedge CLK or negedge RST_n)
begin
  
  if(!RST_n)
  begin
  counter     <= 0 ;
  load_flag   <= 0 ;
  shift_reg   <= 0 ;
  end


  else if(Data_valid || load_flag) begin
     shift_reg   <= P_DATA;

     if(Data_valid) begin
       load_flag <= 1;
     end

     else begin
       load_flag <= 0;
     end

     end


  else if(serial_enable || counter)
  begin

     if(counter != 3'd7) 
     begin
     shift_reg   <= {1'b0 , shift_reg[7:1]};
     counter     <= counter + 1;
     end

     else
     begin
     counter     <= 0; 
     end
  end
  
end


endmodule