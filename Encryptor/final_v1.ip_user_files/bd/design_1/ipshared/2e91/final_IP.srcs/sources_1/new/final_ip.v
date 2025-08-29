`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2025 07:11:16 PM
// Design Name: 
// Module Name: final_ip
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



module final_ip #(
    parameter DATA_WIDTH = 32,
    parameter N_values = 4
)(
    input wire axi_clk,
    input wire axi_reset_n,

    // AXI-Stream Slave for Image Read DMA (axi_dma_0)
    input wire s_axis_image_valid,
    input wire [DATA_WIDTH-1:0] s_axis_image_data,
    input wire s_axis_image_last,
    output wire s_axis_image_ready,

    // AXI-Stream Master for Image Write DMA (axi_dma_0)
    output reg m_axis_image_valid,
    output reg [DATA_WIDTH-1:0] m_axis_image_data,
    output reg m_axis_image_last,
    input wire m_axis_image_ready
);


    reg [DATA_WIDTH-1:0] value [N_values-1:0];
    wire [DATA_WIDTH-1:0] processed_value [N_values-1:0];

    reg start_process;
    reg [2:0] read_count;
    reg [2:0] write_count;
    reg last_input;
    
    reg [2:0] state;
    localparam IDLE = 3'b000, READ_SND = 3'b001, READ_PIXELS = 3'b010, PROCESS = 3'b011, WRITE_PIXELS = 3'b100;

    assign s_axis_image_ready = ((state == READ_PIXELS) && s_axis_image_valid) ? 1'b1 : 1'b0;
    
    //instantiations....
    process #(
        .DATA_WIDTH(DATA_WIDTH),
        .N_values(N_values)
    ) process_inst (
        .in_value_0(value[0]),
        .in_value_1(value[1]),
        .in_value_2(value[2]),
        .in_value_3(value[3]),
        .start(start_process),
        .out_value_0(processed_value[0]),
        .out_value_1(processed_value[1]),
        .out_value_2(processed_value[2]),
        .out_value_3(processed_value[3])
    );
    
    
    
    always @(posedge axi_clk or negedge axi_reset_n) begin
        if (!axi_reset_n) begin
            state <= IDLE;
            read_count <= 0;
            write_count <= 0;
            start_process<=1'b0;
            m_axis_image_valid <= 1'b0;
            m_axis_image_last <= 1'b0;
            value[0] = 32'b0;
            value[1] = 32'b0;
            value[2] = 32'b0;
            value[3] = 32'b0;            
        end else begin
            case (state)
                IDLE: begin
                    value[0] = 32'b0;
                    value[1] = 32'b0;
                    value[2] = 32'b0;
                    value[3] = 32'b0;
                    read_count <=0;
                    start_process <=1'b0;
                    write_count <=0;
                    if (s_axis_image_valid) begin
                        state <= READ_PIXELS;
                    end
                end
                
                READ_PIXELS: begin
                    if (s_axis_image_valid && s_axis_image_ready) begin
                        value[read_count] <= s_axis_image_data;
                        read_count <= read_count + 1;
                        if (read_count == 3) begin
                            state <= PROCESS;
                            start_process <=1'b1;
                        end
                    end
                end

                PROCESS: begin
                    // value[0] <= (value[0] & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
                    // value[1] <= (value[1] & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
                    // value[2] <= (value[2] & 32'b1111_1100_1111_1100_1111_1100_1111_1100);  
                    // value[3] <= (value[3] & 32'b1111_1100_1111_1100_1111_1100_1111_1100);
                    value[0] <= processed_value[0];
                    value[1] <= processed_value[1];
                    value[2] <= processed_value[2]; 
                    value[3] <= processed_value[3];                   
                    write_count <= 0;
                    read_count <=0;
                    state <= WRITE_PIXELS;
                end

                WRITE_PIXELS: begin
                    start_process <= 1'b0;
                    if (write_count < 4) begin
                        // m_axis_image_valid <= 1'b1; ---- issue valid stays 1 whenever the ready turns 1 the older data get's latched so
                        if (m_axis_image_ready) begin
                            m_axis_image_valid <= 1'b1; //wrote here to make sure the valid is 1 only when ready is 1
                            m_axis_image_data <= value[write_count];
                                                                   
                            if (write_count == 3 & last_input) begin
                                m_axis_image_last <= 1'b1;
                            end else begin
                                m_axis_image_last <= 1'b0;
                            end 
                            
                            write_count <= write_count + 1;
                        end
                    end else begin
                        m_axis_image_valid <= 1'b0;
                        m_axis_image_last <= 1'b0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    always@(posedge axi_clk or negedge axi_reset_n) begin
        if (!axi_reset_n) begin
            last_input <= 1'b0;
        end
        else if(state == IDLE) begin
            last_input <= 1'b0;
        end
        else if(s_axis_image_last) begin
            last_input <= 1'b1;
        end
    end

endmodule

