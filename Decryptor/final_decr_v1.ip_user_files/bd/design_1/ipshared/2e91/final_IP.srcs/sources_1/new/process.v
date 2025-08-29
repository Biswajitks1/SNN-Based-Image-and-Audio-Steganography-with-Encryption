`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2025 08:03:18 PM
// Design Name: 
// Module Name: process
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


module process #(
    parameter DATA_WIDTH = 32,
    parameter N_values = 4
)(
    input wire [DATA_WIDTH-1:0] in_value_0,
    input wire [DATA_WIDTH-1:0] in_value_1,
    input wire [DATA_WIDTH-1:0] in_value_2,
    input wire [DATA_WIDTH-1:0] in_value_3,
    input wire start,
    output reg [DATA_WIDTH-1:0] out_value_0,
    output reg [DATA_WIDTH-1:0] out_value_1,
    output reg [DATA_WIDTH-1:0] out_value_2,
    output reg [DATA_WIDTH-1:0] out_value_3
    );

    reg [DATA_WIDTH-1:0] noise_0;
    reg [DATA_WIDTH-1:0] noise_1;
    reg [DATA_WIDTH-1:0] noise_2;
    reg [DATA_WIDTH-1:0] noise_3;

    reg [DATA_WIDTH-1:0] noisy_value_0;
    reg [DATA_WIDTH-1:0] noisy_value_1;
    reg [DATA_WIDTH-1:0] noisy_value_2;
    reg [DATA_WIDTH-1:0] noisy_value_3;

    always @(*) begin
        if (start) begin
            // generating noise
            noise_0[7:0] = (in_value_0[7:0] ^ in_value_1[7:0] ^ in_value_2[7:0]) & 8'h03;
            noise_0[15:8] = (in_value_0[15:8] ^ in_value_1[15:8] ^ in_value_2[15:8]) & 8'h03;
            noise_0[23:16] = (in_value_0[23:16] ^ in_value_1[23:16] ^ in_value_2[23:16]) & 8'h03;
            noise_0[31:24] = (in_value_0[31:24] ^ in_value_1[31:24] ^ in_value_2[31:24]) & 8'h03;

            noise_1[7:0] = (in_value_1[7:0] ^ in_value_2[7:0] ^ in_value_3[7:0]) & 8'h03;
            noise_1[15:8] = (in_value_1[15:8] ^ in_value_2[15:8] ^ in_value_3[15:8]) & 8'h03;
            noise_1[23:16] = (in_value_1[23:16] ^ in_value_2[23:16] ^ in_value_3[23:16]) & 8'h03;
            noise_1[31:24] = (in_value_1[31:24] ^ in_value_2[31:24] ^ in_value_3[31:24]) & 8'h03;

            noise_2[7:0] = (in_value_2[7:0] ^ in_value_3[7:0] ^ in_value_1[7:0]) & 8'h03;
            noise_2[15:8] = (in_value_2[15:8] ^ in_value_3[15:8] ^ in_value_1[15:8]) & 8'h03;
            noise_2[23:16] = (in_value_2[23:16] ^ in_value_3[23:16] ^ in_value_1[23:16]) & 8'h03;
            noise_2[31:24] = (in_value_2[31:24] ^ in_value_3[31:24] ^ in_value_1[31:24]) & 8'h03;

            noise_3[7:0] = (in_value_3[7:0] ^ in_value_0[7:0] ^ in_value_1[7:0]) & 8'h03;
            noise_3[15:8] = (in_value_3[15:8] ^ in_value_0[15:8] ^ in_value_1[15:8]) & 8'h03;
            noise_3[23:16] = (in_value_3[23:16] ^ in_value_0[23:16] ^ in_value_1[23:16]) & 8'h03;
            noise_3[31:24] = (in_value_3[31:24] ^ in_value_0[31:24] ^ in_value_1[31:24]) & 8'h03;

            // adding noise
            noisy_value_0[7:0] = ((in_value_0[7:0] + noise_0[7:0]) > 8'hFF)? 8'hFF : (in_value_0[7:0] + noise_0[7:0]);
            noisy_value_0[15:8] = ((in_value_0[15:8] + noise_0[15:8]) > 8'hFF)? 8'hFF : (in_value_0[15:8] + noise_0[15:8]);
            noisy_value_0[23:16] = ((in_value_0[23:16] + noise_0[23:16]) > 8'hFF)? 8'hFF : (in_value_0[23:16] + noise_0[23:16]);
            noisy_value_0[31:24] = ((in_value_0[31:24] + noise_0[31:24]) > 8'hFF)? 8'hFF : (in_value_0[31:24] + noise_0[31:24]);

            noisy_value_1[7:0] = ((in_value_1[7:0] + noise_1[7:0])> 8'hFF)? 8'hFF : (in_value_1[7:0] + noise_1[7:0]);
            noisy_value_1[15:8] = ((in_value_1[15:8] + noise_1[15:8])> 8'hFF)? 8'hFF : (in_value_1[15:8] + noise_1[15:8]);
            noisy_value_1[23:16] = ((in_value_1[23:16] + noise_1[23:16])> 8'hFF)? 8'hFF : (in_value_1[23:16] + noise_1[23:16]);
            noisy_value_1[31:24] = ((in_value_1[31:24] + noise_1[31:24])> 8'hFF)? 8'hFF : (in_value_1[31:24] + noise_1[31:24]);

            noisy_value_2[7:0] = ((in_value_2[7:0] + noise_2[7:0])> 8'hFF)? 8'hFF : (in_value_2[7:0] + noise_2[7:0]);
            noisy_value_2[15:8] = ((in_value_2[15:8] + noise_2[15:8])> 8'hFF)? 8'hFF : (in_value_2[15:8] + noise_2[15:8]);
            noisy_value_2[23:16] = ((in_value_2[23:16] + noise_2[23:16])> 8'hFF)? 8'hFF : (in_value_2[23:16] + noise_2[23:16]);
            noisy_value_2[31:24] = ((in_value_2[31:24] + noise_2[31:24])> 8'hFF)? 8'hFF : (in_value_2[31:24] + noise_2[31:24]);

            noisy_value_3[7:0] = ((in_value_3[7:0] + noise_3[7:0])> 8'hFF)? 8'hFF : (in_value_3[7:0] + noise_3[7:0]);
            noisy_value_3[15:8] = ((in_value_3[15:8] + noise_3[15:8])> 8'hFF)? 8'hFF : (in_value_3[15:8] + noise_3[15:8]);
            noisy_value_3[23:16] = ((in_value_3[23:16] + noise_3[23:16])> 8'hFF)? 8'hFF : (in_value_3[23:16] + noise_3[23:16]);
            noisy_value_3[31:24] = ((in_value_3[31:24] + noise_3[31:24])> 8'hFF)? 8'hFF : (in_value_3[31:24] + noise_3[31:24]);

                
            out_value_0 = (noisy_value_0 & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
            out_value_1 = (noisy_value_1 & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
            out_value_2 = (noisy_value_2 & 32'b1111_1100_1111_1100_1111_1100_1111_1100);  
            out_value_3 = (noisy_value_3 & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
        end
        else begin
            out_value_0 = 0;
            out_value_1 = 0;
            out_value_2 = 0;
            out_value_3 = 0;
        end
    end


endmodule
