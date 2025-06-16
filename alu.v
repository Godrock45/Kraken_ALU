module add16(
    input [15:0]LHS,
    input [15:0]RHS,
    input clip,
    output [15:0] sum,
    output [15:0]carry);
    
    // add16: 16-bit ripple-carry adder using custom full adder instances.
   

    genvar i;
    generate 
        for(i=0;i<16;i=i+1)begin : addy_daddy
            if(i==0) begincd ..
                add_krde_sanam(.A(LHS[i]),.B(RHS[i]),.clip(clip),.sum(sum),.carry(carry[i]));
            end
            else
            begin
                add_krde_sanam(.A(LHS[i]),.B(RHS[i]),.clip(carry[i-1]),.sum(sum),.carry(carry[i]));
            end
        end
    endgenerate

     // Splits logic into generate blocks for per-bit processing.



endmodule
module add_krde_sanam(
    input A,
    input B,
    input clip,//(initial carry)
    output sum,
    output carry);//(final carry)
    assign sum=A^B^clip;
assign carry=(B&A)|(A&clip)|(B&clip);
endmodule



module not(
    input [31:0]in,
    output [31:0] out);
    genvar i;
    generate 
        for(i=0;i<32;i=i+1)begin : notty_daddy
        assign out[i]=~in[i];
        end
        endgenerate
endmodule


module Xor(
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
add16 t(.LHS(LHS[15:0]),.RHS(RHS[15:0]),.clip(1'b0),.sum(sum[15:0]),.carry(carry));
add16 n(.LHS(LHS[31:16]),.RHS(RHS[31:16]),.clip(carry),.sum(sum0),.carry());
add16 l(.LHS(LHS[31:16]),.RHS(RHS[31:16]),.clip(carry),.sum(sum1),.carry());
assign sum[31:16]=(carry==1'b0)? sum0:sum1;

// using a carry select design for optimisation
wire rnx,xorx;
not(.in(LHS),.out(rnx));
Xor(.in1(LHS),.in2(RHS),.out(xorx));
//function calls for respective methods and operations
always @(*) begin
     case(opp)
     3'b000 : res= LHS&RHS;   // AND
     3'b001 : res=LHS|RHS;   // OR
     3'b010 : res= sum;     //ADD
     3'b011 : res=rnx;      //NOT
     3'b100 : res=LHS+(~RHS+1);  //SUB using 2's complement
     3'b101 : res= xorx;       //XOR
     default : res= 32'hDEADBEEF; //Error 
     endcase

    
end
endmodule






