import alu_pkg::*;
module ALU(
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
            ADD:
                begin
                    {CarryFlag, result} = SrcA + SrcB;
                    OverflowFlag = ((SrcA[31] == SrcB[31]) && (SrcA[31] != result[31]));
                end
            SUB: 
                begin
                    {CarryFlag, result} = SrcA - SrcB;
                    CarryFlag = ~CarryFlag;
                    OverflowFlag = ((SrcA[31] != SrcB[31] )&&(SrcA[31] != result[31]));
                end
            XOR: result = SrcA^SrcB;
            OR: result = SrcA|SrcB;
            AND: result = SrcA&SrcB;
            SLL: result = SrcA << SrcB[4:0];
            SRL: result = SrcA >> SrcB[4:0];
            SRA: result = $signed(SrcA) >>> SrcB[4:0];
            SLT: result = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
            SLTU: result = (SrcA < SrcB) ? 32'd1 : 32'd0;
            B_PASS: result = SrcB;
            default: result = '0;
        endcase
        ZeroFlag = (result == '0); 
        NegativeFlag = result[31];
    end
endmodule