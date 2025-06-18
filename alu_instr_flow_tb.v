`timescale 1ns / 1ps

module alu_instr_flow_tb;

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
        $dumpfile("sim/alu_instr_flow.vcd");
        $dumpvars(0, alu_instr_flow_tb);

        // ---- Combo 1: SLT then ADD result ----
        A = -5; B = 10; opcode = 3'b110; #10; // SLT = 1
        A = result; B = 32'd100; opcode = 3'b010; #10; // ADD → 1 + 100 = 101

        // ---- Combo 2: NOT then SUB result ----
        A = 32'hFFFF0000; opcode = 3'b011; B = 0; #10; // NOT → 00000FFF
        A = result; B = 32'h00000F0F; opcode = 3'b100; #10; // SUB → should be ~F0F

        // ---- Combo 3: XOR then AND ----
        A = 32'h12345678; B = 32'hFFFF0000; opcode = 3'b101; #10; // XOR
        A = result; B = 32'h0F0F0F0F; opcode = 3'b000; #10; // AND masked

        // ---- Combo 4: SUB then NAND ----
        A = 100; B = 25; opcode = 3'b100; #10; // SUB = 75
        A = result; B = 75; opcode = 3'b111; #10; // NAND → ~(75 & 75)

        $finish;
    end

endmodule
