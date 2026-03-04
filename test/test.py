import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test(dut):
    imem = dut.if_pipeline_stage_inst.instruction_memory_inst.instruction_mem
   
    imem[0].value = 0x403100b3 #sub x1, x2, x3
    imem[1].value= 0x0062c233#xor x4, x5, x6
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    regs = dut.id_pipeline_stage_inst.register_file_inst.registers

    regs[2].value = 10   # x2
    regs[3].value = 3    # x3 
    regs[5].value = 0xFF # x5
    regs[6].value = 0x0F # x6  

    await RisingEdge(dut.clk)

    await RisingEdge(dut.clk)
    
    for _ in range(20):
        await RisingEdge(dut.clk)

    dump_regs(dut)

def dump_regs(dut, filename="regdump.txt"):
    regs = dut.id_pipeline_stage_inst.register_file_inst.registers
    with open(filename, "w") as f:
        for i in range(32):
            val = regs[i].value.integer
            f.write(f"x{i:<2} = {val:#010x}  ({val})\n")