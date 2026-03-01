import alu_pkg::*;
import imm_gen_pkg::*;
interface control_signals_if;
    logic RegWrite;
    logic [1:0] ResultSrc;
    logic Branch;
    logic Jump;
    logic DataWE;
    logic [1:0] DataSize;
    logic AluSrcBSel;
    t_alu_op AluOp;
    t_imm ImmSel;

    modport control_unit (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataSize,
        output AluSrcBSel,
        output AluOp,
        output ImmSel
    );

    modport ID_STAGE_OUT (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataSize,
        output AluSrcBSel,
        output AluOp
    );
    
    modport ID_EX_IN (
        input RegWrite,
        input ResultSrc,
        input Branch,
        input Jump,
        input DataWE,
        input DataSize,
        input AluSrcBSel,
        input AluOp    
    );

    modport ID_EX_OUT (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataSize,
        output AluSrcBSel,
        output AluOp
    );

    modport EX_STAGE_IN(
        input Branch,
        input Jump,
        input AluSrcBSel,
        input AluOp
    );

    modport EX_MEM_IN(
        input RegWrite,
        input ResultSrc,
        input DataWE,
        input DataSize
    );

    modport EX_MEM_OUT(
        output RegWrite,
        output ResultSrc,
        output DataWE,
        output DataSize
    );

    modport MEM_STAGE_IN (
        input DataWE,
        input DataSize
    );

    modport MEM_WB_IN(
        input RegWrite,
        input ResultSrc
    );

    modport MEM_WB_OUT(
        output RegWrite,
        output ResultSrc
    );
    modport WB_STAGE_IN(
        input RegWrite,
        input ResultSrc
    );
endinterface