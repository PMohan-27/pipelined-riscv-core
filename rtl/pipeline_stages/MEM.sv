module MEM_PIPELINE_STAGE(
    input logic clk, rst,
    input logic [31:0] AluResult_MEM, WriteData_MEM,
    
    output logic [31:0] ReadData_MEM,

    control_signals_if.MEM_STAGE_IN ctrl_in
);
    data_mem data_memory_inst(
        .clk(clk), 
        .rst(rst), 
        .DataType(ctrl_in.DataType),
        .DataWE(ctrl_in.DataWE),
        .Address(AluResult_MEM),
        .WriteData(WriteData_MEM),
        .ReadData(ReadData_MEM)
    );

endmodule