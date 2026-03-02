module top(
    input logic clk,
    input logic rst
);
    logic [31:0] instruction_IF, PC_IF, PCPlus4_IF;
    logic [31:0] instruction_ID, PC_ID, PCPlus4_ID;
    logic [4:0] rs1_ID, rs2_ID, rd_ID;
    logic [31:0] RD1_ID, RD2_ID;
    logic [31:0] ImmExt_ID;

    control_signals_if ID_CONTROL_SIGNALS();
    control_signals_if EX_CONTROL_SIGNALS();


    IF_PIPELINE_STAGE if_pipeline_stage_inst(
        .clk(clk), 
        .rst(rst),
        .AluResult_EX(), 
        .PCTarget_EX(),
        .PCSrc_EX(),
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

        .instruction_ID(instruction_ID),
        .PC_ID(PC_ID),
        .PCPlus4_ID(PCPlus4_ID)
    );

    ID_PIPELINE_STAGE id_pipeline_stage_inst(
        .clk(clk),
        .rst(rst),
        .instruction_ID(instruction_ID),
        .rd_WB(),
        .RegWrite_WB(),
        .Result_WB(),

        .rs1_ID(rs1_ID),
        .rs2_ID(rs2_ID),
        .rd_ID(rd_ID),
        .RD1_ID(RD1_ID),
        .RD2_ID(RD2_ID),
        .ImmExt_ID(ImmExt_ID),

        .ID_ctrl_out(ID_CONTROL_SIGNALS)
    );

    ID_EX_PIPELINE_REG id_ex_pipeline_reg_inst(
        .clk(clk),
        .rst(rst),
        .rs1_ID(rs1_ID),
        .rs2_ID(rs2_ID),
        .rd_ID(rd_ID),
        .PC_ID(PC_ID),
        .ImmExt_ID(ImmExt_ID),
        .PCPlus4_ID(PCPlus4_ID),
        .RD1_ID(RD1_ID),
        .RD2_ID(RD2_ID),
        .Flush(),

        .RD1_EX(),
        .RD2_EX(),
        .rs1_EX(),
        .rs2_EX(),
        .rd_EX(),
        .PC_EX(),
        .PCPlus4_EX(),
        .ImmExt_EX(),

        .ctrl_in(ID_CONTROL_SIGNALS),
        .ctrl_out(EX_CONTROL_SIGNALS)
    );
endmodule