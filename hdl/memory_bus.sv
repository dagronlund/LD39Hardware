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
	logic enable;
	logic data_ready;

	modport master(
		output address, data_in, write_enable, enable,
		input data_out, data_ready
	);

	modport slave(
		input address, data_in, write_enable, enable,
		output data_out, data_ready
	);

	modport tb(
		input address, data_in, write_enable, enable, data_out, data_ready
	);

endinterface
