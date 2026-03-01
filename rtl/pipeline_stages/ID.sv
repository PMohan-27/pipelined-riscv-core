module ID_PIPELINE_STAGE(
    input logic clk, rst,
    input logic [31:0] instruction_ID,
    input logic [4:0]  rd_WB,
    input logic RegWrite_WB,
    input logic [31:0] Result_WB,

    output logic [4:0] rs1_ID, rs2_ID, rd_ID,
    output logic [31:0] RD1_ID, RD2_ID, ImmExt_ID,
    
    control_signals_if.ID_STAGE_OUT ID_ctrl_out

 );
    control_signals_if control_signals();
    logic [4:0] rs1, rs2 ,rd;
    logic [6:0] opcode;
    logic [6:0] funct7;
    logic [2:0] funct3;

    
    always_comb begin
        opcode = instruction_ID[6:0];
        funct7 = instruction_ID[31:25];
        funct3 = instruction_ID[14:12];
        rs1 = instruction_ID[19:15];
        rs2 = instruction_ID[24:20];
        rd = instruction_ID[11:7];
    end

    control_unit control_unit_inst(
        .opcode(opcode), 
        .funct7(funct7),
        .funct3(funct3),
        .ctrl_out(control_signals)
    );

    reg_file register_file_inst(
        .clk (clk),
        .rst (rst),
        .A1  (rs1),
        .A2  (rs2),
        .A3  (rd_WB),
        .WD3 (Result_WB),
        .WE3 (RegWrite_WB),
        .RD1 (RD1_ID),
        .RD2 (RD2_ID)
    );

    imm_gen imm_gen_inst(
        .instruction(instruction_ID),
        .ImmSel(control_signals.ImmSel),
        .ImmExt(ImmExt_ID)
    );

endmodule