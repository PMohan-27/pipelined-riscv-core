module top(
    input logic clk, rst
);
    logic [31:0] data_rdata;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic data_we;
    logic data_re;
    logic [2:0]  data_type;

    cpu cpu_inst(
        .clk(clk),
        .rst(rst),
        .data_rdata(data_rdata),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_we(data_we),
        .data_type(data_type),
        .data_re(data_re),
        .data_stall(1'b0)
    );

    data_mem data_memory_inst(
        .clk(clk), 
        .rst(rst), 
        .DataType(data_type),
        .DataWE(data_we),
        .Address(data_addr),
        .WriteData(data_wdata),
        .ReadData(data_rdata)
    );

endmodule