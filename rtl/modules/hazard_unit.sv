module hazard_unit(
    input logic [4:0] rs1_ID, rs2_ID,
    input logic [4:0] rs1_EX, rs2_EX,
    input t_result_src ResultSrc_EX,
    input t_pcsrc PCSrc_EX,
    input logic [4:0] rd_MEM, rd_WB,
    input logic RegWrite_MEM, RegWrite_WB,

    output logic Stall_IF,
    output logic Stall_ID, Flush_ID,
    output logic Flush_EX
);
    always_comb begin
        Flush_ID = PCSrc_EX != PC_NEXT;
        Flush_EX = PCSrc_EX != PC_NEXT;
    end

endmodule