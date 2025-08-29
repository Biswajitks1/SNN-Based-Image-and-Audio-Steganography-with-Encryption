// (c) Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// (c) Copyright 2022-2025 Advanced Micro Devices, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: biswajitks.org:biswajit:final_ip:5.0
// IP Revision: 6

`timescale 1ns/1ps

(* IP_DEFINITION_SOURCE = "package_project" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_final_ip_0_0 (
  axi_clk,
  axi_reset_n,
  s_axis_image_valid,
  s_axis_image_data,
  s_axis_image_last,
  s_axis_image_ready,
  m_axis_image_valid,
  m_axis_image_data,
  m_axis_image_last,
  m_axis_image_ready
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME axi_clk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 axi_clk CLK" *)
input wire axi_clk;
input wire axi_reset_n;
input wire s_axis_image_valid;
input wire [31 : 0] s_axis_image_data;
input wire s_axis_image_last;
output wire s_axis_image_ready;
output wire m_axis_image_valid;
output wire [31 : 0] m_axis_image_data;
output wire m_axis_image_last;
input wire m_axis_image_ready;

  final_ip #(
    .DATA_WIDTH(32),
    .N_values(4)
  ) inst (
    .axi_clk(axi_clk),
    .axi_reset_n(axi_reset_n),
    .s_axis_image_valid(s_axis_image_valid),
    .s_axis_image_data(s_axis_image_data),
    .s_axis_image_last(s_axis_image_last),
    .s_axis_image_ready(s_axis_image_ready),
    .m_axis_image_valid(m_axis_image_valid),
    .m_axis_image_data(m_axis_image_data),
    .m_axis_image_last(m_axis_image_last),
    .m_axis_image_ready(m_axis_image_ready)
  );
endmodule
