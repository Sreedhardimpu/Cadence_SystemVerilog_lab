timeunit 1ns;
timeprecision 1ps;
// Code your design here
module counter (
  input logic [4:0] data,
  input logic load,
  input logic enable,
  input logic clk,
  input logic rst,
  output wire [4:0] out
);
 
  logic [4:0] reg_q;
  
  always_ff @(posedge clk or negedge rst) begin
    if(!rst)
      begin
        reg_q <= 4'b0;
      end
    else if(load)
      begin
        reg_q <= data;
      end
    else if(enable)
      begin
        reg_q++;
      end
  end
  
  assign out = reg_q;
endmodule
  
