`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

module cpu_alu (
	input logic clock, reset,

	input logic [3:0] operation,
	input logic [15:0] operand, operator,
	input logic [15:0] status_in,

	output logic [15:0] result,
	output logic [15:0] status_out
);

	localparam integer MSB = 15;

	localparam logic [3:0] ADD = 4'h0,
		ADDC = 4'h1,
		SUB = 4'h2,
		SUBB = 4'h3,
		AND = 4'h4,
		OR = 4'h5,
		XOR = 4'h6,
		NOT = 4'h7,
		BIT = 4'h8,
		CMP = 4'h9,
		TST = 4'hA;

	logic carry_borrow_in, zero_in, sign_in, overflow_in, bit_in;
	assign {bit_in, overflow_in, sign_in, zero_in, carry_borrow_in} = status_in[4:0];

	logic carry_borrow_out, zero_out, sign_out, overflow_out, bit_out;
	logic [15:0] result_temp;

	always_comb begin
		{bit_out, overflow_out, sign_out, zero_out, carry_borrow_out} = 5'b0;
		result_temp = 16'b0;

		case (operation)
		ADD: begin
			{carry_borrow_out, result} = operand + operator;
			zero_out = (result == 16'b0);
			sign_out = result[MSB];
			overflow_out = (operand[MSB] == operator[MSB]) && (operand[MSB] != result[MSB]);
		end
		ADDC: begin
			{carry_borrow_out, result} = operand + operator + carry_borrow_in;
			zero_out = (result == 16'b0);
			sign_out = result[MSB];
			overflow_out = (operand[MSB] == operator[MSB]) && (operand[MSB] != result[MSB]);
		end
		SUB: begin
			{carry_borrow_out, result} = operand - operator;
			zero_out = (result == 16'b0);
			sign_out = result[MSB];
			overflow_out = (operand[MSB] == operator[MSB]) && (operand[MSB] != result[MSB]);
		end
		SUBB: begin
			{carry_borrow_out, result} = operand - operator - carry_borrow_in;
			zero_out = (result == 16'b0);
			sign_out = result[MSB];
			overflow_out = (operand[MSB] == operator[MSB]) && (operand[MSB] != result[MSB]);
		end

		AND: begin
			result = operand & operator;
			zero_out = (result == 16'b0);
		end
		OR: begin
			result = operand | operator;
			zero_out = (result == 16'b0);
		end
		XOR: begin
			result = operand ^ operator;
			zero_out = (result == 16'b0);
		end
		NOT: begin
			result = ~operand;
			zero_out = (result == 16'b0);
		end

		BIT: begin
			result = operand;
			bit_out = operand[operator[3:0]];
		end

		CMP: begin
			result = operand;
			{carry_borrow_out, result_temp} = operand - operator;
			zero_out = (result_temp == 16'b0);
			sign_out = result_temp[MSB];
			overflow_out = (operand[MSB] == operator[MSB]) && (operand[MSB] != result_temp[MSB]);
		end
		TST: begin
			result = operand;
			result_temp = operand & operator;
			zero_out = (result_temp == 16'b0);
		end

		default: begin
			result = operand;
		end
		endcase

		status_out = {11'b0, bit_out, overflow_out, sign_out, zero_out, carry_borrow_out};
	end

endmodule
