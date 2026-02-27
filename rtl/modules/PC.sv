module PC(
    input  logic clk, rst, stall_IF,
    input  logic [31:0] PC_in,
    output logic [31:0] PC_out
);

    always_ff @(posedge clk or posedge rst) begin
        if(rst == 1'b1)begin
            PC_out <= 32'b0;
        end
        else if(!stall_IF) begin
            PC_out <= PC_in;
        end
    end

endmodule