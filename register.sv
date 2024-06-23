timeunit 1ns;
timeprecision 1ps;
// Code your design here
module register (
  input logic [7:0] data,
  input logic enable,
  input logic clk,
  input logic rst,
  output wire [7:0] out
);
 
  logic [7:0] reg_q;
  
  always @(posedge clk or negedge rst) begin
    if(!rst)
      begin
        reg_q <= 8'b0;
      end
    else if(!enable)
      begin
        //do nothing
      end
    else
      begin
        reg_q <= data;
      end
  end
  
  assign out = reg_q;
endmodule
  
