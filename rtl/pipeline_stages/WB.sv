module WB_PIPELINE_STAGE(
    input logic [31:0] AluResult_WB, ReadData_WB, PCTarget_WB, PCPlus4_WB,

    output logic [31:0] Result_WB,
    control_signals_if.WB_STAGE_IN ctrl_in
);

    always_comb begin
        case(ctrl_in.ResultSrc) 
            ALU_RESULT: Result_WB = AluResult_WB; 
            DATA_MEM_RESULT: Result_WB = ReadData_WB; 
            PC_TARGET_RESULT: Result_WB = PCTarget_WB;
            PC_PLUS4_RESULT: Result_WB = PCPlus4_WB;
            default: Result_WB = AluResult_WB; 
        endcase
    end

endmodule