import alu_pkg::*;
module CPU_ALU(
    input  t_alu_op AluOp,
    input  logic [31:0] SrcA, SrcB,
    output logic ZeroFlag, OverflowFlag, NegativeFlag, CarryFlag,
    output logic[31:0] result
);
    
    always_comb begin
        // defaults
        CarryFlag = 0;
        OverflowFlag = 0;
        result = '0;
        
        unique case(AluOp)
            ALU_OP_ADD:
                begin
                    {CarryFlag, result} = SrcA + SrcB;
                    OverflowFlag = ((SrcA[31] == SrcB[31]) && (SrcA[31] != result[31]));
                end
            ALU_OP_SUB: 
                begin
                    {CarryFlag, result} = SrcA - SrcB;
                    CarryFlag = ~CarryFlag;
                    OverflowFlag = ((SrcA[31] != SrcB[31] )&&(SrcA[31] != result[31]));
                end
            ALU_OP_XOR: result = SrcA^SrcB;
            ALU_OP_OR: result = SrcA|SrcB;
            ALU_OP_AND: result = SrcA&SrcB;
            ALU_OP_SLL: result = SrcA << SrcB[4:0];
            ALU_OP_SRL: result = SrcA >> SrcB[4:0];
            ALU_OP_SRA: result = $signed(SrcA) >>> SrcB[4:0];
            ALU_OP_SLT: result = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            ALU_OP_SLTU: result = (SrcA < SrcB) ? 32'd1 : 32'd0;
            ALU_OP_B_PASS: result = SrcB;
            default: result = '0;
        endcase
        ZeroFlag = (result == '0); 
        NegativeFlag = result[31];
    end
endmodule