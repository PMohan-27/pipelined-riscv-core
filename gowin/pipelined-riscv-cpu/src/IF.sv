import control_unit_pkg::*;
module IF_PIPELINE_STAGE(
    input logic clk, rst,
    input logic [31:0] AluResult_EX, PCTarget_EX,
    input t_pcsrc PCSrc_EX,
    input logic Stall,

    output logic [31:0] instruction_IF, PC_IF, PCPlus4_IF
);
    logic [31:0] PC_in;
    logic [31:0] PC_out;

    always_comb begin
        case (PCSrc_EX)
            PC_NEXT: PC_in = PC_out + 4;
            PC_IMM: PC_in = PCTarget_EX;
            PC_RS1_IMM: PC_in = AluResult_EX;
            default: PC_in = PC_out + 4;
        endcase
    end

    PC pc_inst (
        .clk(clk),
        .rst(rst),
        .PC_in(PC_in),
        .PC_out(PC_out),
        .Stall(Stall)
    );

    instruction_memory instruction_memory_inst (
        .clk(clk),
        .address(PC_out),
        .instruction(instruction_IF)
    );

    always_comb begin
        PC_IF = PC_out;
        PCPlus4_IF = PC_out + 4;
    end
endmodule