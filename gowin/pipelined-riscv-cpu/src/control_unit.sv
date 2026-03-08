import alu_pkg::*;
import control_unit_pkg::*;
import imm_gen_pkg::*;
module control_unit(
    input logic [6:0] opcode, funct7,
    input logic [2:0] funct3,

    control_signals_if.control_unit ctrl_out
);
    always_comb begin
        unique case(opcode) 
            OPCODE_R_TYPE: begin 
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump  = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b0;
                ctrl_out.ImmSel = I_IMM;
                case({funct7[5],funct3}) 
                    {FUNCT7_STD, FUNCT3_ADD_SUB}: ctrl_out.AluOp = ALU_OP_ADD;
                    {FUNCT7_ALT, FUNCT3_ADD_SUB}: ctrl_out.AluOp = ALU_OP_SUB;
                    {FUNCT7_STD, FUNCT3_XOR}: ctrl_out.AluOp = ALU_OP_XOR;
                    {FUNCT7_STD, FUNCT3_OR}: ctrl_out.AluOp = ALU_OP_OR;
                    {FUNCT7_STD, FUNCT3_AND}: ctrl_out.AluOp = ALU_OP_AND;
                    {FUNCT7_STD, FUNCT3_SLL}: ctrl_out.AluOp = ALU_OP_SLL;
                    {FUNCT7_STD, FUNCT3_SRL_SRA}: ctrl_out.AluOp = ALU_OP_SRL;
                    {FUNCT7_ALT, FUNCT3_SRL_SRA}: ctrl_out.AluOp =   ALU_OP_SRA;
                    {FUNCT7_STD, FUNCT3_SLT}: ctrl_out.AluOp = ALU_OP_SLT;
                    {FUNCT7_STD, FUNCT3_SLTU}: ctrl_out.AluOp = ALU_OP_SLTU;
                    default: ctrl_out.AluOp = ALU_OP_ADD;
                endcase
            end
            OPCODE_I_TYPE: begin
                ctrl_out.ImmSel = I_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump  = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                case (funct3) 
                    FUNCT3_ADD_SUB: ctrl_out.AluOp = ALU_OP_ADD;
                    FUNCT3_XOR: ctrl_out.AluOp = ALU_OP_XOR;
                    FUNCT3_OR: ctrl_out.AluOp = ALU_OP_OR;
                    FUNCT3_AND: ctrl_out.AluOp = ALU_OP_AND;
                    FUNCT3_SLL: ctrl_out.AluOp = ALU_OP_SLL;
                    FUNCT3_SRL_SRA: ctrl_out.AluOp = funct7[5] ? ALU_OP_SRA : ALU_OP_SRL;
                    FUNCT3_SLT: ctrl_out.AluOp = ALU_OP_SLT;
                    FUNCT3_SLTU: ctrl_out.AluOp = ALU_OP_SLTU;
                    default: ctrl_out.AluOp = ALU_OP_ADD;
                endcase
            end
            OPCODE_LOAD: begin
                ctrl_out.ImmSel = I_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = DATA_MEM_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.AluOp = ALU_OP_ADD;
                case(funct3) 
                    FUNCT3_LW: ctrl_out.DataType = WORD;
                    FUNCT3_LH: ctrl_out.DataType = HALFWORD;
                    FUNCT3_LB: ctrl_out.DataType = BYTE;
                    FUNCT3_LHU: ctrl_out.DataType = U_HALFWORD;
                    FUNCT3_LBU: ctrl_out.DataType = U_BYTE;
                    default: ctrl_out.DataType = WORD;
                endcase
            end
            OPCODE_STORE: begin
                ctrl_out.ImmSel = S_IMM;
                ctrl_out.RegWrite = 1'b0;
                ctrl_out.ResultSrc = DATA_MEM_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_NONE;
                ctrl_out.DataWE = 1'b1;
                ctrl_out.AluOp = ALU_OP_ADD;
                case(funct3) 
                    FUNCT3_SW: ctrl_out.DataType = WORD;
                    FUNCT3_SH: ctrl_out.DataType = HALFWORD;
                    FUNCT3_SB: ctrl_out.DataType = BYTE;
                    default: ctrl_out.DataType = WORD;
                endcase
            end
            OPCODE_BRANCH: begin
                ctrl_out.ImmSel = B_IMM;
                ctrl_out.RegWrite = 1'b0;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b0;
                ctrl_out.Jump = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluOp = ALU_OP_SUB;
                case(funct3)
                    FUNCT3_BEQ: ctrl_out.Branch = BR_BEQ;
                    FUNCT3_BNE: ctrl_out.Branch = BR_BNE;
                    FUNCT3_BLT: ctrl_out.Branch = BR_BLT;
                    FUNCT3_BGE: ctrl_out.Branch = BR_BGE;
                    FUNCT3_BLTU: ctrl_out.Branch = BR_BLTU;
                    FUNCT3_BGEU: ctrl_out.Branch = BR_BGEU;
                    default: ctrl_out.Branch = BR_NONE;
                endcase
            end
            OPCODE_JAL: begin
                ctrl_out.ImmSel = J_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = PC_PLUS4_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b0;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_JAL;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluOp = ALU_OP_ADD;
            end
            OPCODE_JALR: begin
                ctrl_out.ImmSel = I_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = PC_PLUS4_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_JALR;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluOp = ALU_OP_ADD;
            end
            OPCODE_LUI: begin
                ctrl_out.ImmSel = U_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluOp = ALU_OP_B_PASS;
            end
            OPCODE_AUIPC: begin
                ctrl_out.ImmSel = U_IMM;
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.AluSrcASel = 1'b1;
                ctrl_out.AluSrcBSel = 1'b1;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluOp = ALU_OP_ADD;
            end
            default: begin 
                ctrl_out.ImmSel = I_IMM;
                ctrl_out.RegWrite = 1'b0;
                ctrl_out.ResultSrc = ALU_RESULT;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump  = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataType = WORD;
                ctrl_out.AluSrcASel = 1'b0;
                ctrl_out.AluSrcBSel = 1'b0;
                ctrl_out.AluOp = ALU_OP_ADD;
            end
        endcase
    end

endmodule