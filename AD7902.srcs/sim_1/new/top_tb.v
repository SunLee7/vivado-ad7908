`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 21:11:05
// Design Name: 
// Module Name: top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_tb;

reg clk;                   
reg rst_n;
 
initial begin            
clk = 0;
rst_n = 0;
#80000 rst_n = 1;
end

wire [15:0]data1   ;
wire [15:0]data2   ;
wire cs1     ;
wire cs2     ;
wire cnv     ;
wire clk_ad  ;
wire data_in;

reg [31:0] adc_cnt;
parameter ADC_CNT_NUM = 50_000_000 / 40960;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        adc_cnt <= 0;
    else if(adc_cnt >= ADC_CNT_NUM)
        adc_cnt <= 0;
    else
        adc_cnt <= adc_cnt + 1;
end

wire adc_convert_clk;
assign adc_convert_clk = (adc_cnt == 0)? 1: 0;

always #20 clk = ~clk;      

assign data_in = 1;

ad7902 ad7902_u(
    .clk(clk),
    .rst_n(rst_n),
    .data1(data1),
    .data2(data2),
    .ad_start(adc_convert_clk),
    .cs1(cs1),
    .cs2(cs2),
    .cnv(cnv),
    .data_in(data_in)

);

endmodule
