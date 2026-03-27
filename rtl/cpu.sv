module cpu(
    input logic clk,
    input logic rst,


    input  logic [31:0] data_rdata,
    output logic [31:0] data_addr,
    output logic [31:0] data_wdata,
    output logic data_we,
    output logic data_re,
    output logic [2:0]  data_type,
    input logic data_done,

    input  logic [31:0] instr_data, 
    input  logic instr_valid,
    output logic [31:0] instr_addr, //PC
    output logic instr_ready,
    output logic flush_instr

);
    logic [31:0] instruction_IF, PC_IF, PCPlus4_IF;
    logic [31:0] instruction_ID, PC_ID, PCPlus4_ID;
    logic [4:0] rs1_ID, rs2_ID, rd_ID;
    logic [31:0] RD1_ID, RD2_ID;
    logic [31:0] ImmExt_ID;

    logic [31:0] RD1_EX, RD2_EX;
    logic [4:0] rs1_EX, rs2_EX;
    logic [31:0] PC_EX, PCPlus4_EX, ImmExt_EX;

    logic [31:0] PCTarget_EX;
    logic [4:0] rd_EX;
    logic [31:0] AluResult_EX, WriteData_EX;
    t_pcsrc PCSrc_EX;

    logic [31:0] PCPlus4_MEM;
    logic [4:0] rd_MEM;
    logic [31:0] AluResult_MEM, WriteData_MEM;
    logic [31:0] ReadData_MEM;

    logic [31:0] AluResult_WB, ReadData_WB;
    logic [4:0] rd_WB;
    logic [31:0] PCPlus4_WB;
    logic [31:0] Result_WB;

    control_signals_if ID_CONTROL_SIGNALS();
    control_signals_if EX_CONTROL_SIGNALS();
    control_signals_if MEM_CONTROL_SIGNALS();
    control_signals_if WB_CONTROL_SIGNALS();

    logic Flush_ID_EX, Flush_IF_ID, Stall_PC, Stall_IF_ID, Stall_ID_EX, Stall_EX_MEM;
    logic [1:0] ForwardAluSrcA_EX, ForwardAluSrcB_EX;
    logic data_stall;
    CPU_IF_PIPELINE_STAGE if_pipeline_stage_inst(
        .clk(clk), 
        .rst(rst),
        .AluResult_EX(AluResult_EX), 
        .PCTarget_EX(PCTarget_EX),
        .PCSrc_EX(PCSrc_EX),
        .Stall(Stall_PC),
        
        .instr_data(instr_data), 
        .instr_addr(instr_addr),
        .instr_ready(instr_ready),

        .instruction_IF(instruction_IF), 
        .PC_IF(PC_IF), 
        .PCPlus4_IF(PCPlus4_IF)
    );

    CPU_IF_ID_PIPELINE_REG if_id_pipeline_reg_inst(
        .clk(clk),
        .rst(rst),
        .instruction_IF(instruction_IF),
        .PC_IF(PC_IF),
        .PCPlus4_IF(PCPlus4_IF),
        .Stall(Stall_IF_ID),
        .Flush(Flush_IF_ID),

        .instruction_ID(instruction_ID),
        .PC_ID(PC_ID),
        .PCPlus4_ID(PCPlus4_ID)
    );

    CPU_ID_PIPELINE_STAGE id_pipeline_stage_inst(
        .clk(clk),
        .rst(rst),
        .instruction_ID(instruction_ID),
        .rd_WB(rd_WB),
        .RegWrite_WB(WB_CONTROL_SIGNALS.RegWrite),
        .Result_WB(Result_WB),
        
        .rs1_ID(rs1_ID),
        .rs2_ID(rs2_ID),
        .rd_ID(rd_ID),
        .RD1_ID(RD1_ID),
        .RD2_ID(RD2_ID),
        .ImmExt_ID(ImmExt_ID),

        .ctrl_out(ID_CONTROL_SIGNALS)
    );

    CPU_ID_EX_PIPELINE_REG id_ex_pipeline_reg_inst(
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
        .Flush(Flush_ID_EX),
        .Stall(Stall_ID_EX),

        .RD1_EX(RD1_EX),
        .RD2_EX(RD2_EX),
        .rs1_EX(rs1_EX),
        .rs2_EX(rs2_EX),
        .rd_EX(rd_EX),
        .PC_EX(PC_EX),
        .PCPlus4_EX(PCPlus4_EX),
        .ImmExt_EX(ImmExt_EX),

        .ctrl_in(ID_CONTROL_SIGNALS),
        .ctrl_out(EX_CONTROL_SIGNALS)
    );
    

    CPU_EX_PIPELINE_STAGE ex_pipeline_stage_inst(
        .RD1_EX(RD1_EX), 
        .RD2_EX(RD2_EX),
        .PC_EX(PC_EX), 
        .ImmExt_EX(ImmExt_EX),
        .ForwardAluSrcA_EX(ForwardAluSrcA_EX), 
        .ForwardAluSrcB_EX(ForwardAluSrcB_EX),
        .AluResult_MEM(AluResult_MEM), 
        .Result_WB(Result_WB),

        .AluResult_EX(AluResult_EX), 
        .WriteData_EX(WriteData_EX), 
        .PCTarget_EX(PCTarget_EX),
        .PCSrc_EX(PCSrc_EX),

        .ctrl_in(EX_CONTROL_SIGNALS)
    );

    CPU_EX_MEM_PIPELINE_REG ex_mem_pipeline_reg_inst(
        .clk(clk), 
        .rst(rst),
        .PCPlus4_EX(PCPlus4_EX), 
        .rd_EX(rd_EX),
        .AluResult_EX(AluResult_EX), 
        .WriteData_EX(WriteData_EX),
        .Stall(Stall_EX_MEM),

        .PCPlus4_MEM(PCPlus4_MEM), 
        .rd_MEM(rd_MEM),
        .AluResult_MEM(AluResult_MEM), 
        .WriteData_MEM(WriteData_MEM),

        .ctrl_in(EX_CONTROL_SIGNALS),
        .ctrl_out(MEM_CONTROL_SIGNALS)
    );

    CPU_MEM_PIPELINE_STAGE mem_pipeline_stage_inst(
        .AluResult_MEM(AluResult_MEM),
        .WriteData_MEM(WriteData_MEM),
        .data_rdata(data_rdata),
        .data_stall(data_stall),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_we(data_we),
        .data_type(data_type), 
        .data_re(data_re),
        .data_done(data_done),
        .ReadData_MEM(ReadData_MEM),
    
        .ctrl_in(MEM_CONTROL_SIGNALS)
    );

    CPU_MEM_WB_PIPELINE_REG mem_wb_pipeline_reg_inst(
        .clk(clk), 
        .rst(rst),
        .AluResult_MEM(AluResult_MEM), 
        .ReadData_MEM(ReadData_MEM),
        .rd_MEM(rd_MEM),
        .PCPlus4_MEM(PCPlus4_MEM),

        .AluResult_WB(AluResult_WB), 
        .ReadData_WB(ReadData_WB),
        .rd_WB(rd_WB),
        .PCPlus4_WB(PCPlus4_WB),

        .ctrl_in(MEM_CONTROL_SIGNALS),
        .ctrl_out(WB_CONTROL_SIGNALS)
    );

    CPU_WB_PIPELINE_STAGE wb_pipeline_stage_inst(
        .AluResult_WB(AluResult_WB), 
        .ReadData_WB(ReadData_WB), 
        .PCPlus4_WB(PCPlus4_WB),

        .Result_WB(Result_WB),

        .ctrl_in(WB_CONTROL_SIGNALS)
    );

    CPU_hazard_unit hazard_unit_inst(
        .rs1_ID(rs1_ID),
        .rs2_ID(rs2_ID),
        .rs1_EX(rs1_EX), 
        .rs2_EX(rs2_EX),
        .ResultSrc_EX(EX_CONTROL_SIGNALS.ResultSrc),
        .PCSrc_EX(PCSrc_EX),
        .rd_MEM(rd_MEM),
        .rd_WB(rd_WB),
        .rd_EX(rd_EX),
        .RegWrite_EX(EX_CONTROL_SIGNALS.RegWrite),
        .RegWrite_MEM(MEM_CONTROL_SIGNALS.RegWrite), 
        .RegWrite_WB(WB_CONTROL_SIGNALS.RegWrite),
        .data_stall(data_stall),
        .instr_valid(instr_valid),

        .flush_instr(flush_instr),
        .Stall_PC(Stall_PC),
        .Stall_IF_ID(Stall_IF_ID), 
        .Stall_ID_EX(Stall_ID_EX),
        .Stall_EX_MEM(Stall_EX_MEM),
        .Flush_IF_ID(Flush_IF_ID),
        .Flush_ID_EX(Flush_ID_EX),
        .ForwardAluSrcA_EX(ForwardAluSrcA_EX),
        .ForwardAluSrcB_EX(ForwardAluSrcB_EX)
    );

endmodule