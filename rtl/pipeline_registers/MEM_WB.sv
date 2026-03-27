module CPU_MEM_WB_PIPELINE_REG(
    input logic clk, rst,
    input logic [31:0] AluResult_MEM, ReadData_MEM,
    input logic [4:0] rd_MEM,
    input logic [31:0] PCPlus4_MEM,

    output logic [31:0] AluResult_WB, ReadData_WB,
    output logic [4:0] rd_WB,
    output logic [31:0] PCPlus4_WB,

    control_signals_if.MEM_WB_IN ctrl_in,
    control_signals_if.MEM_WB_OUT ctrl_out
);
    always_ff @(posedge clk) begin
        if(!rst) begin
            AluResult_WB <= '0;
            ReadData_WB <= '0;
            rd_WB <= '0;
            PCPlus4_WB <= '0;
            ctrl_out.RegWrite <= '0;
            ctrl_out.ResultSrc <= ALU_RESULT;
        end
        else begin
            AluResult_WB <= AluResult_MEM;
            ReadData_WB <= ReadData_MEM;
            rd_WB <= rd_MEM;
            PCPlus4_WB <= PCPlus4_MEM;
            ctrl_out.RegWrite <= ctrl_in.RegWrite;
            ctrl_out.ResultSrc <= ctrl_in.ResultSrc;
        end
    end
endmodule