import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test(dut):
    imem = dut.if_pipeline_stage_inst.instruction_memory_inst.instruction_mem
    
    imem[0].value  =0x00a48493 #addi x9, x9, 10
    imem[1].value = 0xfe117ee3  # bgeu x2, x1, -4
    # imem[1].value = 0x00108093  # addi x1, x1, 1
    # imem[2].value = 0xfe115ee3  # bge x2, x1, -4
    # imem[3].value = 0x03110293  # addi x5, x2, 49
    imem[2].value = 0x0000006f  # jal x0, .
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    regs = dut.id_pipeline_stage_inst.register_file_inst.registers
    regs[2].value = 1200
    regs[1].value = 10
    await RisingEdge(dut.clk)

    await RisingEdge(dut.clk)
    
    for _ in range(900):
        await RisingEdge(dut.clk)
    
    dump_regs(dut)

def dump_regs(dut, filename="regdump.txt"):
    regs = dut.id_pipeline_stage_inst.register_file_inst.registers
    with open(filename, "w") as f:
        for i in range(32):
            val = regs[i].value.integer
            f.write(f"x{i:<2} = {val:#010x}  ({val})\n")