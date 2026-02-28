package control_unit_pkg;
    typedef enum logic [3:0] { 
        R_TYPE,
        I_TYPE,
        I_LOAD,
        S_TYPE,
        B_TYPE,
        J_JAL,
        I_JALR,
        U_LUI,
        U_AUIPC
    } t_opcode;
endpackage