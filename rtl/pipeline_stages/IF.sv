module IF_PIPELINE_STAGE(
    input logic clk, rst,
    input logic [31:0] AluResult_EX, PCTarget_EX,
    input logic [1:0] PCSel_EX,
    input logic Stall,

    output logic [31:0] instruction_IF, PC_IF, PCPlus4_IF
);
    logic [31:0] PC_in;
    logic [31:0] PC_out;

    always_comb begin
        case (PCSel_EX)
            2'b00: PC_in = PC_out + 4;
            2'b01: PC_in = PCTarget_EX;
            2'b10: PC_in = AluResult_EX;
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
        .address(PC_out),
        .instruction(instruction_IF)
    );

    always_comb begin
        PC_IF = PC_out;
        PCPlus4_IF = PC_out + 4;
    end
endmodule