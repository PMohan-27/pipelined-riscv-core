import alu_pkg::*;
import control_unit_pkg::*;
module control_unit(
    input logic [6:0] opcode, funct7,
    input logic [2:0] funct3,

    control_signals_if.control_unit ctrl_out
);
    always_comb begin
        unique case(opcode) 
            OPCODE_R_TYPE: begin 
                ctrl_out.RegWrite = 1'b1;
                ctrl_out.ResultSrc = 2'b00;
                ctrl_out.Branch = BR_NONE;
                ctrl_out.Jump  = JMP_NONE;
                ctrl_out.DataWE = 1'b0;
                ctrl_out.DataSize = 2'b00;
                ctrl_out.AluSrcBSel = 1'b0;
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
            default: ;
        endcase
    end

endmodule