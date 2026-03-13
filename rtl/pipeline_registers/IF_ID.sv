module IF_ID_PIPELINE_REG(
    input logic clk, rst,
    input logic [31:0] instruction_IF,
    input logic [31:0] PC_IF,
    input logic [31:0] PCPlus4_IF,
    input logic Stall,
    input logic Flush,

    output logic [31:0] instruction_ID,
    output logic [31:0] PC_ID,
    output logic [31:0] PCPlus4_ID
);
    always_ff @(posedge clk) begin
        if(!rst) begin
            instruction_ID <= '0;
            PC_ID <= '0;
            PCPlus4_ID <= '0;
        end
        else if(Flush) begin
            instruction_ID <= '0;
            PCPlus4_ID <= '0;
            PC_ID <= '0;
        end
        else if(!Stall) begin
            instruction_ID <= instruction_IF;
            PC_ID <= PC_IF;
            PCPlus4_ID <= PCPlus4_IF;
        end
    end
endmodule