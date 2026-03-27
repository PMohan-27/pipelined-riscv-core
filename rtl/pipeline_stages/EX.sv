import control_unit_pkg::*;
module CPU_EX_PIPELINE_STAGE(
    input logic [31:0] RD1_EX, RD2_EX,
    input logic [31:0] PC_EX, ImmExt_EX,
    input logic [1:0] ForwardAluSrcA_EX, ForwardAluSrcB_EX,
    input logic [31:0] AluResult_MEM, Result_WB,

    output logic [31:0] AluResult_EX, WriteData_EX, PCTarget_EX,
    output t_pcsrc PCSrc_EX,

    control_signals_if.EX_STAGE_IN ctrl_in
);
    logic ZeroFlag, OverflowFlag, NegativeFlag, CarryFlag;
    CPU_pc_select pc_select_inst(
        .ZeroFlag(ZeroFlag), 
        .OverflowFlag(OverflowFlag),
        .NegativeFlag(NegativeFlag), 
        .CarryFlag(CarryFlag),
        .Jump_EX(ctrl_in.Jump), 
        .Branch_EX(ctrl_in.Branch),
        .PCSrc_EX(PCSrc_EX)
    );

    logic [31:0] AluSrcA, AluSrcB;

    always_comb begin
        if(ctrl_in.AluSrcASel == 1'b0) begin
            case(ForwardAluSrcA_EX)
                2'b00: AluSrcA = RD1_EX;
                2'b01: AluSrcA = Result_WB;
                2'b10: AluSrcA = AluResult_MEM;
                default: AluSrcA = RD1_EX;
            endcase
        end else begin
            AluSrcA = PC_EX;
        end
        if(ctrl_in.AluSrcBSel == 1'b0) begin
            case(ForwardAluSrcB_EX) 
                2'b00: AluSrcB = RD2_EX;
                2'b01: AluSrcB = Result_WB;
                2'b10: AluSrcB = AluResult_MEM;
                default: AluSrcB = RD2_EX;
            endcase
        end else begin
            AluSrcB = ImmExt_EX;
        end
    end

    CPU_ALU ALU_inst(
        .AluOp(ctrl_in.AluOp),
        .SrcA(AluSrcA), 
        .SrcB(AluSrcB),
        .ZeroFlag(ZeroFlag), 
        .OverflowFlag(OverflowFlag), 
        .NegativeFlag(NegativeFlag), 
        .CarryFlag(CarryFlag),
        .result(AluResult_EX)
    );
    always_comb begin
        PCTarget_EX = PC_EX + ImmExt_EX; 

        case(ForwardAluSrcB_EX) 
            2'b00: WriteData_EX = RD2_EX;
            2'b01: WriteData_EX = Result_WB;
            2'b10: WriteData_EX= AluResult_MEM;
            default: WriteData_EX= RD2_EX;
        endcase
    
    end
endmodule