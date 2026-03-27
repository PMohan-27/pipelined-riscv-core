import imm_gen_pkg::*;
module CPU_imm_gen(
    input  logic [31:0] instruction,
    input  t_imm ImmSel,
    output logic  [31:0] ImmExt
);

    always @(*)begin
        case(ImmSel)
        I_IMM: ImmExt = {{20{instruction[31]}}, instruction[31:20]};
        S_IMM: ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        B_IMM: ImmExt = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        J_IMM: ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
        U_IMM: ImmExt = {instruction[31:12], 12'b0};
        default: ImmExt = 32'b0;
        endcase
    end

endmodule