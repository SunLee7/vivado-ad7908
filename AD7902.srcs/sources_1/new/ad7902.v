`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/13 19:43:46
// Design Name: 
// Module Name: ad7902
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


module ad7902(
    input wire clk,
    input wire rst_n,

    output reg [15:0]data1,
    output reg [15:0]data2,

    input wire ad_start,

    output reg cs1,
    output reg cs2,
    output cnv,
    output adc_clk,
    inout wire data_in,

    output data_ready
);

assign adc_clk = clk;

reg [7:0] ad_state;

parameter IDLE = 0;
parameter CONVERTING = 1;
parameter READ_CH1 = 2;
parameter CH1_CH2_BREAK = 3;
parameter READ_CH2 = 4;

assign data_ready = (ad_state == IDLE)? 1: 0;

reg [7:0]convert_cnt;
parameter CONVERTED_CNT_NUM = 40;

reg [4:0]read_cnt1;
reg [4:0]read_cnt2;

reg ad_start_dly;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ad_start_dly <= 0;
    else
        ad_start_dly <= ad_start;
end

// 状态机
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        ad_state <= 0;
    else if(~ad_start_dly && ad_start && ad_state == IDLE) // 上升沿敏感
        ad_state <= CONVERTING;
    else if(convert_cnt >= CONVERTED_CNT_NUM && ad_state == CONVERTING)
        ad_state <= READ_CH1;
    else if(read_cnt1 == 0 && ad_state == READ_CH1)
        ad_state <= CH1_CH2_BREAK;
    else if(ad_state == CH1_CH2_BREAK)
        ad_state <= READ_CH2;
    else if(read_cnt2 == 0 && ad_state == READ_CH2)
        ad_state <= IDLE;
end

// 转换信号标志
// always @(posedge clk or negedge rst_n) begin
//     if(!rst_n)
//         cnv <= 0;
//     else if(ad_state == IDLE)
//         cnv <= 0;
//     else
//         cnv <= 1;
// end

assign cnv = ~ad_start;

// 转换计数710ns
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        convert_cnt <= 0;
    else if(ad_state == CONVERTING)
        convert_cnt <= convert_cnt + 1;
    else
        convert_cnt <= 0;
end

// cs
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cs1 <= 1;
    else if(ad_state == READ_CH1)
        cs1 <= 0;
    else
        cs1 <= 1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cs2 <= 1;
    else if(ad_state == READ_CH2)
        cs2 <= 0;
    else
        cs2 <= 1;
end

// 读取计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        read_cnt1 <= 16;
    else if(ad_state == READ_CH1)
        read_cnt1 <= read_cnt1 - 1;
    else
        read_cnt1 <= 16;
end

// 读取
always @(negedge clk or negedge rst_n) begin
    if(!rst_n)
        data1 <= 0;
    else if(data_in && ad_state == READ_CH1)
        data1[read_cnt1] <= 1;
    else if(!data_in && ad_state == READ_CH1)
        data1[read_cnt1] <= 0;
end

// 读取计数
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        read_cnt2 <= 16;
    else if(ad_state == READ_CH2)
        read_cnt2 <= read_cnt2 - 1;
    else
        read_cnt2 <= 16;
end

// 读取
always @(negedge clk or negedge rst_n) begin
    if(!rst_n)
        data2 <= 0;
    else if(data_in && ad_state == READ_CH2)
        data2[read_cnt2] <= 1;
    else if(!data_in && ad_state == READ_CH2)
        data2[read_cnt2] <= 0;
end

endmodule
