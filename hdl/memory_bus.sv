`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

interface memory_bus();

	logic [15:0] address;
	logic [15:0] data_in;
	logic [15:0] data_out;
	logic write_enable;

endinterface
