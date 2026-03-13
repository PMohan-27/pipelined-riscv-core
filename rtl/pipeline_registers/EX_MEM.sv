module EX_MEM_PIPELINE_REG(
    input logic clk, rst,
    input logic [31:0] PCPlus4_EX,
    input logic [4:0] rd_EX,
    input logic [31:0] AluResult_EX, WriteData_EX,
    input logic Stall,

    output logic [31:0] PCPlus4_MEM,
    output logic [4:0] rd_MEM,
    output logic [31:0] AluResult_MEM, WriteData_MEM,

    control_signals_if.EX_MEM_IN ctrl_in,
    control_signals_if.EX_MEM_OUT ctrl_out
);
    always_ff @(posedge clk) begin
        if(!rst) begin
            PCPlus4_MEM <= '0;
            rd_MEM <= '0;
            AluResult_MEM <= '0;
            WriteData_MEM <= '0;
            ctrl_out.RegWrite <= '0;
            ctrl_out.ResultSrc <= ALU_RESULT;
            ctrl_out.DataWE <= '0;
            ctrl_out.DataType <= WORD;
        end else if (!Stall) begin
            PCPlus4_MEM <= PCPlus4_EX;
            rd_MEM <= rd_EX;
            AluResult_MEM <= AluResult_EX;
            WriteData_MEM <= WriteData_EX;
            ctrl_out.RegWrite <= ctrl_in.RegWrite;
            ctrl_out.ResultSrc <= ctrl_in.ResultSrc;
            ctrl_out.DataWE <= ctrl_in.DataWE;
            ctrl_out.DataType <= ctrl_in.DataType;
        end
    end

endmodule