module CPU_ID_PIPELINE_STAGE(
    input logic clk, rst,
    input logic [31:0] instruction_ID,
    input logic [4:0]  rd_WB,
    input logic RegWrite_WB,
    input logic [31:0] Result_WB,

    output logic [4:0] rs1_ID, rs2_ID, rd_ID,
    output logic [31:0] RD1_ID, RD2_ID, ImmExt_ID,
    
    control_signals_if.ID_STAGE_OUT ctrl_out

 );
    control_signals_if control_signals();
    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    
    always_comb begin
        opcode = instruction_ID[6:0];
        funct7 = instruction_ID[31:25];
        funct3 = instruction_ID[14:12];
        rs1_ID = instruction_ID[19:15];
        rs2_ID = instruction_ID[24:20];
        rd_ID = instruction_ID[11:7];
        ctrl_out.RegWrite = control_signals.RegWrite;
        ctrl_out.ResultSrc = control_signals.ResultSrc;
        ctrl_out.Branch = control_signals.Branch;
        ctrl_out.Jump = control_signals.Jump;
        ctrl_out.DataWE = control_signals.DataWE;
        ctrl_out.DataType = control_signals.DataType;
        ctrl_out.AluSrcASel = control_signals.AluSrcASel;
        ctrl_out.AluSrcBSel = control_signals.AluSrcBSel;
        ctrl_out.AluOp = control_signals.AluOp;
    end

    CPU_control_unit control_unit_inst(
        .opcode(opcode), 
        .funct7(funct7),
        .funct3(funct3),
        .ctrl_out(control_signals)
    );

    CPU_reg_file register_file_inst(
        .clk (clk),
        .rst (rst),
        .A1  (rs1_ID),
        .A2  (rs2_ID),
        .A3  (rd_WB),
        .WD3 (Result_WB),
        .WE3 (RegWrite_WB),
        .RD1 (RD1_ID),
        .RD2 (RD2_ID)
    );

    CPU_imm_gen imm_gen_inst(
        .instruction(instruction_ID),
        .ImmSel(control_signals.ImmSel),
        .ImmExt(ImmExt_ID)
    );

endmodule