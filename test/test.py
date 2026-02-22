import cocotb
from cocotb.clock import Clock

@cocotb.test()
async def test(dut):
    cocotb.start_soon(Clock(dut.clk, 10, units="ns").start())
