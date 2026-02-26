package alu_pkg;
    typedef enum logic [3:0] { 
        ADD, 
        SUB,
        XOR,
        OR,
        AND,
        SLL,
        SRL,
        SRA,
        SLT,
        SLTU,
        B_PASS
    } t_alu_op;
endpackage