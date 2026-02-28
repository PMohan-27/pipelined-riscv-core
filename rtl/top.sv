module top(
    input logic clk,
    input logic rst
);
    logic [31:0] instruction_IF, PC_IF, PCPlus4_IF;
    
    IF_PIPELINE_STAGE if_pipeline_stage_inst(
        .clk(clk), 
        .rst(rst),
        .AluResult_EX(), 
        .PCTarget_EX(),
        .PCSel_EX(),
        .Stall(),

        .instruction_IF(instruction_IF), 
        .PC_IF(PC_IF), 
        .PCPlus4_IF(PCPlus4_IF)
    );

    IF_ID_PIPELINE_REG if_id_pipeline_reg_inst(
        .clk(clk),
        .rst(rst),
        .instruction_IF(instruction_IF),
        .PC_IF(PC_IF),
        .PCPlus4_IF(PCPlus4_IF),
        .Stall(),
        .Flush(),

        .instruction_ID(),
        .PC_ID(),
        .PCPlus4_ID()
    );

endmodule