`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

module cpu(
	input logic clock, reset,

	memory_bus.master inst,
    memory_bus.master data
);

	// module cpu_registers (
	// 	input logic clock, reset,

	// 	input logic write_enable,
	// 	input logic [3:0] write_index,
	// 	input logic [15:0] write_data,

	// 	input logic [3:0] reg_a_index,
	// 	output logic [15:0] reg_a_data,

	// 	input logic [3:0] reg_b_index,
	// 	output logic [15:0] reg_b_data,

	// 	// Instruction pointer
	// 	input logic ip_write_enable,
	// 	input logic [15:0] ip_data_in,
	// 	output logic [15:0] ip_data_out,

	// 	// Status register
	// 	input logic write_status,
	// 	input logic [15:0] status_data_in,
	// 	output logic [15:0] status_data_out
	// );

	// module cpu_alu (
	// 	input logic clock, reset,

	// 	input logic [3:0] operation,
	// 	input logic [15:0] operand, operator,
	// 	input logic [15:0] status_in,

	// 	output logic [15:0] result,
	// 	output logic [15:0] status_out
	// );

	// module cpu_branch (
	// 	input logic clock, reset,

	// 	input logic [15:0] status_in,
	// 	input logic [3:0] condition,

	// 	output logic branch
	// );

endmodule
