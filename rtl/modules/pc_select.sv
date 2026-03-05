import control_unit_pkg::*;
module pc_select(
    input logic ZeroFlag, OverflowFlag, NegativeFlag, CarryFlag,
    input t_jump Jump_EX, 
    input t_branch Branch_EX,
    output t_pcsrc PCSrc_EX
);
    always_comb begin
        PCSrc_EX = PC_NEXT;

        if(Jump_EX != JMP_NONE) begin
            case(Jump_EX) 
                JMP_JAL:  PCSrc_EX = PC_IMM;
                JMP_JALR: PCSrc_EX = PC_RS1_IMM;
                default: PCSrc_EX = PC_NEXT;
            endcase
        end
        else begin
            case(Branch_EX)
                BR_NONE:  PCSrc_EX = PC_NEXT;
                BR_BEQ:   PCSrc_EX = (ZeroFlag)  ? PC_IMM : PC_NEXT;
                BR_BNE:   PCSrc_EX = (!ZeroFlag) ? PC_IMM : PC_NEXT;
                BR_BLT:   PCSrc_EX = (NegativeFlag ^ OverflowFlag) ? PC_IMM : PC_NEXT;
                BR_BGE:   PCSrc_EX = !(NegativeFlag ^ OverflowFlag) ? PC_IMM : PC_NEXT;
                BR_BLTU:  PCSrc_EX = (!CarryFlag) ? PC_IMM : PC_NEXT;
                BR_BGEU:  PCSrc_EX = CarryFlag ? PC_IMM : PC_NEXT;
                default:  PCSrc_EX = PC_NEXT;
            endcase
        end
    end
endmodule