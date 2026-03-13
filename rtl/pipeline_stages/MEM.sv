module MEM_PIPELINE_STAGE(
    input logic [31:0] AluResult_MEM, WriteData_MEM,
    input  logic [31:0] data_rdata,

    output logic [31:0] ReadData_MEM,
    output logic [31:0] data_addr,
    output logic [31:0] data_wdata,
    output logic        data_we,
    output logic [2:0]  data_type, 
    output logic data_re,

    control_signals_if.MEM_STAGE_IN ctrl_in
);

    assign ReadData_MEM = data_rdata;
    assign data_addr = AluResult_MEM;
    assign data_wdata = WriteData_MEM;
    assign data_we = ctrl_in.DataWE;
    assign data_type = ctrl_in.DataType;
    assign data_re = (ctrl_in.ResultSrc == DATA_MEM_RESULT) && !ctrl_in.DataWE;
    

endmodule