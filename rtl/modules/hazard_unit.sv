module CPU_hazard_unit(
    input logic [4:0] rs1_ID, rs2_ID,
    input logic [4:0] rs1_EX, rs2_EX,
    input t_result_src ResultSrc_EX,
    input t_pcsrc PCSrc_EX,
    input logic [4:0] rd_MEM, rd_WB, rd_EX,
    input logic RegWrite_EX, RegWrite_MEM, RegWrite_WB, 
    input logic data_stall,
    input logic instr_valid,

    output logic Stall_PC,
    output logic Stall_IF_ID, Flush_IF_ID,
    output logic Flush_ID_EX, Stall_ID_EX,
    output logic Stall_EX_MEM,
    output logic flush_instr,
    output logic [1:0] ForwardAluSrcA_EX, ForwardAluSrcB_EX
);
    always_comb begin

        Stall_PC = 1'b0;
        Stall_IF_ID = 1'b0;
        Stall_ID_EX = 1'b0;
        Flush_IF_ID = 1'b0;
        Flush_ID_EX = 1'b0;
        Stall_EX_MEM = 1'b0;
        flush_instr = 1'b0;

        ForwardAluSrcA_EX = 2'b00;
        ForwardAluSrcB_EX = 2'b00;

        if (PCSrc_EX != PC_NEXT) begin
            Flush_IF_ID = 1'b1;
            Flush_ID_EX = 1'b1;
            flush_instr = 1'b1;
        end

        if (data_stall) begin
            Stall_PC = 1'b1;
            Stall_IF_ID = 1'b1;
            Stall_ID_EX = 1'b1;
            Stall_EX_MEM = 1'b1;
            
            if (PCSrc_EX == PC_NEXT) begin
                Flush_ID_EX = 1'b0; 
            end
        end 

        else if (!instr_valid) begin
            Stall_PC = 1'b1;
            Stall_IF_ID = 1'b1;
            Flush_ID_EX = 1'b1;
        end 

        else begin
            if ((ResultSrc_EX == DATA_MEM_RESULT || ResultSrc_EX == ALU_RESULT) && 
                (rd_EX == rs1_ID || rd_EX == rs2_ID) &&
                rd_EX != 5'b0 && RegWrite_EX) begin
                
                Stall_PC = 1'b1;
                Stall_IF_ID = 1'b1;
                Flush_ID_EX = 1'b1;
            end
        end
        
        if(RegWrite_MEM && rd_MEM != 5'b0 && rd_MEM == rs1_EX) begin
            ForwardAluSrcA_EX = 2'b10;
        end else if(RegWrite_WB && rd_WB != 5'b0 && rd_WB == rs1_EX) begin
            ForwardAluSrcA_EX = 2'b01;
        end

        if(RegWrite_MEM && rd_MEM != 5'b0 && rd_MEM == rs2_EX) begin
            ForwardAluSrcB_EX = 2'b10;
        end else if(RegWrite_WB && rd_WB != 5'b0 && rd_WB == rs2_EX) begin
            ForwardAluSrcB_EX = 2'b01;
        end
        
    end

endmodule