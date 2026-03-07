import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def test(dut):
    imem = dut.if_pipeline_stage_inst.instruction_memory_inst.instruction_mem
    
    load_instructions(imem)
    
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())

    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    regs = dut.id_pipeline_stage_inst.register_file_inst.registers

    await RisingEdge(dut.clk)
    
    for _ in range(10000):
        await RisingEdge(dut.clk)
    
    dump_regs(dut)
    dump_instrs(dut)
    dump_data_mem(dut)

def dump_regs(dut, filename="regdump.txt"):
    regs = dut.id_pipeline_stage_inst.register_file_inst.registers
    with open(filename, "w") as f:
        for i in range(32):
            val = regs[i].value.integer
            f.write(f"x{i:<2} = {val:#010x}  ({val})\n")

def dump_instrs(dut, filename="instrdump.txt"):
    with open(filename, "w") as f:
        imem = dut.if_pipeline_stage_inst.instruction_memory_inst.instruction_mem
        for i in range(256):
            val = imem[i].value.integer
            f.write(f"imem[{i}] = {val:#010x}  ({val})\n")

def dump_data_mem(dut, filename="dmemdump.txt"):
    with open(filename, "w") as f:
        dmem = dut.mem_pipeline_stage_inst.data_memory_inst.memory
        for i in range(256):
            val = dmem[i].value.integer
            f.write(f"imem[{i}] = {val:#010x}  ({val})\n")

def load_instructions(imem):
    with open('assembly/test.hex') as f:
        addr = 0
        bytes_buf = []
        for line in f:
            line = line.strip()
            if line.startswith("@"):
                addr = int(line[1:], 16)
            else:
                for byte in line.split():
                    bytes_buf.append(int(byte, 16))

    for i in range(0, len(bytes_buf), 4):
        word = (bytes_buf[i+3] << 24 | bytes_buf[i+2] << 16 |
                bytes_buf[i+1] << 8  | bytes_buf[i])
        imem[addr + i//4].value = word