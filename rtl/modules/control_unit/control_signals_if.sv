import alu_pkg::*;
import imm_gen_pkg::*;
import control_unit_pkg::*;
interface control_signals_if;
    logic RegWrite;
    t_result_src ResultSrc;
    t_branch Branch;
    t_jump Jump;
    logic DataWE;
    t_data_type DataType;
    logic AluSrcBSel;
    logic AluSrcASel;
    t_alu_op AluOp;
    t_imm ImmSel;

    modport control_unit (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataType,
        output AluSrcBSel,
        output AluSrcASel,
        output AluOp,
        output ImmSel
    );

    modport ID_STAGE_OUT (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataType,
        output AluSrcBSel,
        output AluSrcASel,
        output AluOp
    );
    
    modport ID_EX_IN (
        input RegWrite,
        input ResultSrc,
        input Branch,
        input Jump,
        input DataWE,
        input DataType,
        input AluSrcBSel,
        input AluSrcASel,
        input AluOp    
    );

    modport ID_EX_OUT (
        output RegWrite,
        output ResultSrc,
        output Branch,
        output Jump,
        output DataWE,
        output DataType,
        output AluSrcBSel,
        output AluSrcASel,
        output AluOp
    );

    modport EX_STAGE_IN(
        input Branch,
        input Jump,
        input AluSrcBSel,
        input AluSrcASel,
        input AluOp
    );

    modport EX_MEM_IN(
        input RegWrite,
        input ResultSrc,
        input DataWE,
        input DataType
    );

    modport EX_MEM_OUT(
        output RegWrite,
        output ResultSrc,
        output DataWE,
        output DataType
    );

    modport MEM_STAGE_IN (
        input ResultSrc,
        input DataWE,
        input DataType
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
        input ResultSrc
    );
endinterface