`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 20:22:55
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst_n,

    output cs1,
    output cs2,
    output cnv,
    output adc_clk,
    input data_in
    );

wire clk_100M;
wire clk_10M;
wire clk_50M;
BUFG BUFG_u(.I(clk), .O(clk_50M));

wire [15:0]data1;
wire [15:0]data2;

reg [31:0] adc_cnt;
parameter ADC_CNT_NUM = 10_000_000 / 40960;

always @(posedge clk_10M or negedge rst_n) begin
    if(!rst_n)
        adc_cnt <= 0;
    else if(adc_cnt >= ADC_CNT_NUM)
        adc_cnt <= 0;
    else
        adc_cnt <= adc_cnt + 1;
end

wire adc_convert_clk;
assign adc_convert_clk = (adc_cnt <= 10)? 1: 0;

wire ad_data_ready;

ad7902 ad7902_u(
    .clk(clk_10M),
    .rst_n(rst_n),
    .data1(data1),
    .data2(data2),
    .ad_start(adc_convert_clk),
    .cs1(cs1),
    .cs2(cs2),
    .cnv(cnv),
    .adc_clk(adc_clk),
    .data_in(data_in),
    .data_ready(ad_data_ready)

);

clk_wiz_0 clk_wiz_0_u(
    .clk_in1(clk_50M),
    .clk_out1(clk_100M),
    .clk_out2(clk_10M)
);

ila_0 ila_0_u(
    .clk(clk_50M),
    .probe0(clk_10M),
    .probe1(adc_convert_clk),
    .probe2(cs1),
    .probe3(cs2),
    .probe4(cnv),
    .probe5(data_in),
    .probe6(data1),
    .probe7(data2),
    .probe8(ad_data_ready)
);

ila_1 ila_1_u(
    .clk(clk_50M),
    .probe0(data1),
    .probe1(data2),
    .probe2(ad_data_ready)
);

endmodule
