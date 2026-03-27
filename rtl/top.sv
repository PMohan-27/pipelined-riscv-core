module top(
    input logic clk, rst
);
    logic [31:0] data_rdata;
    logic [31:0] data_addr;
    logic [31:0] data_wdata;
    logic data_we;
    logic data_re;
    logic [2:0]  data_type;

    logic [31:0] instr_data; 
    logic instr_valid;
    logic [31:0] instr_addr;
    logic instr_ready;
    logic flush_instr;

    cpu cpu_inst(
        .clk(clk),
        .rst(rst),
        .data_rdata(data_rdata),
        .data_addr(data_addr),
        .data_wdata(data_wdata),
        .data_we(data_we),
        .data_type(data_type),
        .data_re(data_re),
        .data_done(1'b1),

        .instr_data(instr_data), 
        .instr_valid(1'b1),
        .instr_addr(instr_addr),
        .instr_ready(instr_ready),
        .flush_instr(flush_instr)
    );
    CPU_instruction_memory instr_mem_inst(
        .address(instr_addr),
        .instruction(instr_data)
    );
    CPU_data_mem data_memory_inst(
        .clk(clk), 
        .rst(rst), 
        .DataType(data_type),
        .DataWE(data_we),
        .Address(data_addr),
        .WriteData(data_wdata),
        .ReadData(data_rdata)
    );

endmodule