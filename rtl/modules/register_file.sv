module reg_file(
    input  logic clk, rst,
    input  logic [4:0] A1, A2, A3,
    input  logic [31:0] WD3,
    input  logic WE3,
    output logic [31:0] RD1, RD2
);  

    reg [31:0] registers [0:31];

    // since x0 is set to 0 
    assign RD1 = (A1 == 5'b0) ? 32'b0 : 
             (WE3 && A3 == A1 && A3 != 5'b0) ? WD3 : registers[A1];
    assign RD2 = (A2 == 5'b0) ? 32'b0 : 
             (WE3 && A3 == A2 && A3 != 5'b0) ? WD3 : registers[A2];
    integer i = 0;

    always_ff @(posedge clk)begin
        if(!rst)begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'h0;
            end
        end
        else if(WE3 && A3 != 5'b0)begin
            registers[A3] <= WD3;
        end
    end


endmodule