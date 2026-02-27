module instruction_memory ( 
    input  logic [31:0] address,
    output logic [31:0] instruction 
);
    reg [31:0] instruction_mem[0:255];

    assign instruction = instruction_mem[address[31:2]];
endmodule