import alu_pkg::*;
module ID_EX_PIPELINE_REG (
    input logic clk, rst,
    input logic [4:0] rs1_ID, rs2_ID, rd_ID,
    input logic [31:0] PC_ID, ImmExt_ID, PCPlus4_ID,
    input logic [31:0] RD1_ID, RD2_ID,
    input logic Flush, Stall,
    
    output logic [31:0] RD1_EX, RD2_EX,
    output logic [4:0] rs1_EX, rs2_EX, rd_EX,
    output logic [31:0] PC_EX, PCPlus4_EX, ImmExt_EX,

    control_signals_if.ID_EX_IN ctrl_in,
    control_signals_if.ID_EX_OUT ctrl_out
);

    always_ff @(posedge clk) begin
        if(rst) begin
            RD1_EX <= '0;
            RD2_EX <= '0;
            rs1_EX <= '0;
            rs2_EX <= '0;
            rd_EX <= '0;
            PC_EX <= '0; 
            PCPlus4_EX <= '0;
            ImmExt_EX <= '0;
            ctrl_out.RegWrite <= '0;
            ctrl_out.ResultSrc <= ALU_RESULT;
            ctrl_out.Branch <= BR_NONE;
            ctrl_out.Jump <= JMP_NONE;
            ctrl_out.DataWE <= '0;
            ctrl_out.DataType <= WORD;
            ctrl_out.AluSrcBSel <= '0;
            ctrl_out.AluSrcASel  <= '0;
            ctrl_out.AluOp <= ALU_OP_ADD;
        end
        else if(Flush) begin
            RD1_EX <= '0;
            RD2_EX <= '0;
            rs1_EX <= '0;
            rs2_EX <= '0;
            rd_EX <= '0;
            PC_EX <= '0; 
            PCPlus4_EX <= '0;
            ImmExt_EX <= '0;
            ctrl_out.RegWrite <= '0;
            ctrl_out.ResultSrc <= ALU_RESULT;
            ctrl_out.Branch <= BR_NONE;
            ctrl_out.Jump <= JMP_NONE;
            ctrl_out.DataWE <= '0;
            ctrl_out.DataType <= WORD;
            ctrl_out.AluSrcBSel <= '0;
            ctrl_out.AluSrcASel  <= '0;
            ctrl_out.AluOp <= ALU_OP_ADD;
        end  else if (!Stall) begin
            ctrl_out.RegWrite <= ctrl_in.RegWrite;
            ctrl_out.ResultSrc <= ctrl_in.ResultSrc;
            ctrl_out.Branch <= ctrl_in.Branch;
            ctrl_out.Jump <= ctrl_in.Jump;
            ctrl_out.DataWE <= ctrl_in.DataWE;
            ctrl_out.DataType <= ctrl_in.DataType;
            ctrl_out.AluSrcBSel <= ctrl_in.AluSrcBSel;
            ctrl_out.AluSrcASel <= ctrl_in.AluSrcASel;
            ctrl_out.AluOp <= ctrl_in.AluOp;
            RD1_EX <= RD1_ID;
            RD2_EX <= RD2_ID;
            rs1_EX <= rs1_ID;
            rs2_EX <= rs2_ID;
            rd_EX <= rd_ID;
            PC_EX <= PC_ID;
            PCPlus4_EX <= PCPlus4_ID;
            ImmExt_EX <= ImmExt_ID;
        end
    end 

endmodule