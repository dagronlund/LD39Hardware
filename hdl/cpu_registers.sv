`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

module cpu_registers (
	input logic clock, reset,

	input logic write_enable,
	input logic [3:0] write_index,
	input logic [15:0] write_data,

	input logic [3:0] reg_a_index,
	output logic [15:0] reg_a_data,

	input logic [3:0] reg_b_index,
	output logic [15:0] reg_b_data,

	// Instruction pointer
	input logic ip_write_enable,
	input logic [15:0] ip_data_in,
	output logic [15:0] ip_data_out,

	// Status register
	input logic write_status,
	input logic [15:0] status_data_in,
	output logic [15:0] status_data_out
);

	localparam logic [3:0] IP_REG = 4'hC,
		SP_REG = 4'hD,
		STATUS_REG = 4'hE,
		INT_REG = 4'hF;

	logic [3:0] registers [3:0];

	always_ff @ (posedge clock) begin
		if (reset) begin
			registers <= '{16{16'h0}};
		end else begin
			if (write_enable) begin
				registers[write_index] <= write_data;
			end
			if (ip_write_enable) begin
				registers[IP_REG] <= ip_data_in;
			end
			if (write_status) begin
				registers[STATUS_REG] <= status_data_in;
			end
		end
	end

	always_comb begin
		reg_a_data = registers[reg_a_index];
		reg_b_data = registers[reg_b_index];
		ip_data_out = registers[IP_REG];
		status_data_out = registers[STATUS_REG];
	end

endmodule
