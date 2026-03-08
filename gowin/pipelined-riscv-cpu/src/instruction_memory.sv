module instruction_memory ( 
    input clk,
    input  logic [31:0] address,
    output logic [31:0] instruction 
);
    /* verilator lint_off WIDTHTRUNC */

    reg [31:0] instruction_mem[0:32]/* synthesis syn_ramstyle = "block_ram" */;
    always_ff @(posedge clk) begin
        instruction <= instruction_mem[address[31:2]];
    end
endmodule