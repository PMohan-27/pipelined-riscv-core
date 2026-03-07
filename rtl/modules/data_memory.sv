module data_mem(
    input logic clk, rst, 
    input  t_data_type DataType,
    input  logic DataWE,
    input  logic [31:0] Address, WriteData,
    output logic [31:0] ReadData
);

    /* verilator lint_off WIDTHTRUNC */
    logic [31:0] memory [0:256];
    integer i;

    logic misalign;
    logic [7:0] byte_selected;
    logic [15:0] hw_selected;

    always_comb begin
        case(DataType)
            U_BYTE, BYTE: misalign = 1'b0;
            U_HALFWORD, HALFWORD: misalign = (Address[0] != 1'b0);
            WORD: misalign = (Address[1:0] != 2'b00);
            default: misalign = 1'b1;
        endcase

        case(Address[1:0])
        // bytes 1 to 4
            2'b00: byte_selected = memory[Address[31:2]][7:0];
            2'b01: byte_selected = memory[Address[31:2]][15:8];
            2'b10: byte_selected = memory[Address[31:2]][23:16];
            2'b11: byte_selected = memory[Address[31:2]][31:24];
            default: byte_selected = 8'b0;
        endcase
        //first or second half of word
        hw_selected = (Address[1] == 1'b0) 
                    ? memory[Address[31:2]][15:0] 
                    : memory[Address[31:2]][31:16];

        if(misalign == 1'b1)begin
            ReadData = 32'bx;
        end
        else begin
            case(DataType)
                U_BYTE: ReadData = {24'b0,byte_selected};
                BYTE: ReadData = {{24{byte_selected[7]}}, byte_selected};
                U_HALFWORD: ReadData = {16'b0, hw_selected} ;
                HALFWORD:ReadData = {{16{hw_selected[15]}}, hw_selected};
                WORD: ReadData = memory[Address[31:2]];
                default: ReadData = 32'b0;
            endcase
        end
    end
    
   always_ff @(posedge clk) begin
    if(rst == 1'b1) begin
        for (i = 0; i < 32; i = i + 1) begin
            memory[i] <= 32'h0;
        end
    end
    else begin
        if(DataWE & !misalign)begin
            case(DataType) 
                BYTE, U_BYTE: begin
                    case(Address[1:0])
                        2'b00: memory[Address[31:2]][7:0]   <= WriteData[7:0];
                        2'b01: memory[Address[31:2]][15:8]  <= WriteData[7:0];
                        2'b10: memory[Address[31:2]][23:16] <= WriteData[7:0];
                        2'b11: memory[Address[31:2]][31:24] <= WriteData[7:0];
                    endcase
                end
                U_HALFWORD, HALFWORD: begin
                    if(Address[1] == 1'b0)
                        memory[Address[31:2]][15:0]  <= WriteData[15:0];
                    else
                        memory[Address[31:2]][31:16] <= WriteData[15:0];
                end
                WORD: memory[Address[31:2]] <= WriteData;
                default: ;
            endcase
        end
    end
   end

endmodule