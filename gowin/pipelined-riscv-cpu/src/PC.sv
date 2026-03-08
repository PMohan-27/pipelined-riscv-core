module PC(
    input  logic clk, rst,
    input  logic [31:0] PC_in,
    output logic [31:0] PC_out,
    input logic Stall
);

    always_ff @(posedge clk or posedge rst) begin
        if(rst == 1'b1)begin
            PC_out <= '0;
        end
        else if(!Stall) begin
            PC_out <= PC_in;
        end
    end

endmodule