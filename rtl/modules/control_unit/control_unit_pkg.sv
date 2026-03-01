package control_unit_pkg;
    localparam logic [6:0]
    OPCODE_R_TYPE  = 7'b0110011,
    OPCODE_I_TYPE  = 7'b0010011,
    OPCODE_LOAD    = 7'b0000011,
    OPCODE_STORE   = 7'b0100011,
    OPCODE_BRANCH  = 7'b1100011,
    OPCODE_JAL     = 7'b1101111,
    OPCODE_JALR    = 7'b1100111,
    OPCODE_LUI     = 7'b0110111,
    OPCODE_AUIPC   = 7'b0010111;

    localparam logic [2:0]
    FUNCT3_ADD_SUB = 3'b000,
    FUNCT3_SLL     = 3'b001,
    FUNCT3_SLT     = 3'b010,
    FUNCT3_SLTU    = 3'b011,
    FUNCT3_XOR     = 3'b100,
    FUNCT3_SRL_SRA = 3'b101,
    FUNCT3_OR      = 3'b110,
    FUNCT3_AND     = 3'b111;

    localparam logic
    FUNCT7_STD = 1'b0,
    FUNCT7_ALT = 1'b1;

endpackage