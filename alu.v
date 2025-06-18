// ========================================================================
// Title       : ALU_Project.v
// Author      : Akshat Singh
// Description : 32-bit Arithmetic Logic Unit supporting AND, OR, XOR, NOT,
//               ADD (with carry select), SUB, SLT, and NAND operations.
// 
// Notes       :
//   - Custom full adder-based ripple adder (add16)
//   - Carry-select optimization in upper 16-bits
//   - Bitwise NOT and XOR as modular Verilog
//   - Signed SLT operation implemented using Verilog's signed comparison
//   - Original naming and structure for clarity and reuse
// ========================================================================
module ALU_Project(
    input [31:0] LHS,
    //left operand
    input [31:0] RHS,
    //right operand
    input [2:0] opp,
    //operator code
    output reg [31:0] res
    //final result
);
wire[31:0] sum;
wire carry;
wire [15:0] sum0,sum1;
wire dummy1,dummy2;
add16 t(.LHS(LHS[15:0]),.RHS(RHS[15:0]),.clip(1'b0),.sum(sum[15:0]),.carry(carry));
add16 n(.LHS(LHS[31:16]),.RHS(RHS[31:16]),.clip(1'b0),.sum(sum0),.carry());
add16 l(.LHS(LHS[31:16]),.RHS(RHS[31:16]),.clip(1'b1),.sum(sum1),.carry());
assign sum[31:16]=(carry==1'b0)? sum0:sum1;
wire signed [31:0] lhs_sign=LHS;
wire signed [31:0] rhs_sign=RHS;
wire [31:0] slt= (lhs_sign<rhs_sign)?32'd1:32'd0;


// using a carry select design for optimisation
wire[31:0] rnx,xorx;
notic lt(.in(LHS),.out(rnx));
Xortic tl(.in1(LHS),.in2(RHS),.out(xorx));
//function calls for respective methods and operations
always @(*) begin
     case(opp)
     3'b000 : res= LHS&RHS;   // AND
     3'b001 : res=LHS|RHS;   // OR
     3'b010 : res= sum;     //ADD
     3'b011 : res=rnx;      //NOT
     3'b100 : res=LHS+(~RHS+1);  //SUB using 2's complement
     3'b101 : res= xorx;       //XOR
     3'b110 : res=slt;       // set less than
     3'b111 : res= ~(LHS&RHS); // NAND
     default : res= 32'hDEADBEEF; //Error 
     endcase

    
end
endmodule

//-----------------------------16-bit Ripple Adder----------------------------

module add16(
    input [15:0]LHS,
    input [15:0]RHS,
    input clip,
    output [15:0] sum,
    output wire carry);
    wire [15:0] intern;
    
    // add16: 16-bit ripple-carry adder using custom full adder instances.
   

    genvar i;
    generate
        for(i=0;i<16;i=i+1) begin : addy_daddy
            if (i == 0) begin
                add_krde_sanam u_add(.A(LHS[i]),.B(RHS[i]),.clip(clip),.sum(sum[i]),.carry(intern[i]));
            end
            if (i != 0) begin
                add_krde_sanam u_add(.A(LHS[i]),.B(RHS[i]),.clip(intern[i-1]),.sum(sum[i]),.carry(intern[i]));
            end
        end
    endgenerate
endmodule
     // Splits logic into generate blocks for per-bit processing.

//-------------------------FULL ADDER CELL------------------------------


module add_krde_sanam(
    input A,
    input B,
    input clip,//(initial carry)
    output sum,
    output carry);//(final carry)
    assign sum=A^B^clip;
assign carry=(B&A)|(A&clip)|(B&clip);
endmodule


//----------------------------BITWISE NOT ------------------------------
module notic(
    input [31:0]in,
    output [31:0] out);
    genvar i;
    generate 
        for(i=0;i<32;i=i+1)begin : notty_daddy
        assign out[i]=~in[i];
        end
        endgenerate
endmodule

// -------------------------- BITWISE XOR -----------------------------
module Xortic(
    input [31:0]in1,
    input [31:0]in2,
    output [31:0] out);
    genvar i;
    generate 
        for(i=0;i<32;i=i+1)begin : exortic_daddy
        assign out[i]=in1[i]^in2[i];
        end
    endgenerate
endmodule






