`timescale 1ns/1ps

/*
 * Project: LD39Hardware
 * Author: David Gronlund
 * 
 * Description:
 *
 */

module cpu_branch (
	input logic clock, reset,

	input logic [15:0] status_in,
	input logic [3:0] condition,

	output logic branch
);

	logic carry_borrow_in, zero_in, sign_in, overflow_in, bit_in;
	assign {bit_in, overflow_in, sign_in, zero_in, carry_borrow_in} = status_in[4:0];

	localparam logic [3:0] UNCONDITIONAL = 4'h0,
		EQUAL = 4'h1,
		NOT_EQUAL = 4'h2,
		BELOW = 4'h3,
		NOT_BELOW = 4'h4,
		NOT_ABOVE = 4'h5,
		ABOVE = 4'h6,
		LESS = 4'h7,
		LESS_EQUAL = 4'h8,
		GREATER = 4'h9,
		GREATER_EQUAL = 4'hA,
		BIT = 4'hB,
		NOT_BIT = 4'hC;

	always_comb begin
		case (condition)
		UNCONDITIONAL: begin
			branch = 1;
		end
		EQUAL: begin
			branch = zero_in;
		end
		NOT_EQUAL: begin
			branch = !zero_in;
		end
		BELOW: begin
			branch = carry_borrow_in;
		end
		NOT_BELOW: begin
			branch = !carry_borrow_in;
		end
		NOT_ABOVE: begin
			branch = carry_borrow_in || zero_in;
		end
		ABOVE: begin
			branch = (!carry_borrow_in) || (!zero_in);
		end
		LESS: begin
			branch = (sign_in != overflow_in);
		end
		LESS_EQUAL: begin
			branch = zero_in || (sign_in != overflow_in);
		end
		GREATER: begin
			branch = (!zero_in) && (sign_in == overflow_in);
		end
		GREATER_EQUAL: begin
			branch = (sign_in == overflow_in);
		end
		BIT: begin
			branch = bit_in;
		end
		NOT_BIT: begin
			branch = !bit_in;
		end
		default: begin
			branch = 0;
		end
		endcase
	end

endmodule
