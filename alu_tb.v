`timescale 1ns / 1ps

module alu_tb;

    reg [31:0] A, B;
    reg [2:0] opcode;
    wire [31:0] result;

    ALU_Project uut (
        .LHS(A),
        .RHS(B),
        .opp(opcode),
        .res(result)
    );

    initial begin
        // Set up VCD dumping
        $dumpfile("sim/alu_wave.vcd");     // name of output dump file
        $dumpvars(0, alu_tb);          // dump everything in this module

        // Start test sequence
        A = 0; B = 0; opcode = 3'b000; #5;

        A = 32'hAAAA_FFFF; B = 32'h0F0F_0F0F; opcode = 3'b000; #10; // AND
        A = 32'hAAAA_0000; B = 32'h0F0F_0F0F; opcode = 3'b001; #10; // OR
        A = 32'd25;        B = 32'd75;        opcode = 3'b010; #10; // ADD
        A = 32'hFFFF_F000; B = 0;             opcode = 3'b011; #10; // NOT
        A = 32'd25;        B = 32'd75;        opcode = 3'b100; #10; // SUB
        A = 32'h1234_5678; B = 32'hFFFF_0000; opcode = 3'b101; #10; // XOR
        A = -10;           B = 5;             opcode = 3'b110; #10; // SLT: 1
        A = 100;           B = -5;            opcode = 3'b110; #10; // SLT: 0
        A = 32'hFFFF_0000; B = 32'hFFFF_0000; opcode = 3'b111; #10; // NAND

        $finish;
    end

endmodule
