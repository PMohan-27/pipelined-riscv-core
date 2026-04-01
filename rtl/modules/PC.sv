module CPU_PC
#(parameter logic[31:0] PC_START = 0)
(
    input  logic clk, rst,
    input  logic [31:0] PC_in,
    output logic [31:0] PC_out,
    input logic Stall
);

    always_ff @(posedge clk) begin
        if(!rst)begin
            PC_out <= PC_START;
        end
        else if(!Stall) begin
            PC_out <= PC_in;
        end
    end

endmodule