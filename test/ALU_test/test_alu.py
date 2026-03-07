
import cocotb
from cocotb.triggers import Timer
import ctypes

def calculate_flags(alu_op, result,a,b):
    result32 = result & 0xFFFFFFFF
    a32 = a & 0xFFFFFFFF
    b32= b & 0xFFFFFFFF
    
    a_sign = (a >> 31) & 1
    b_sign = (b >> 31) & 1
    r_sign = (result32 >> 31) & 1
    zero = (result32 == 0)   
    negative = ((result32 >> 31) & 0b1)
    overflow = 0
    carry = 0
    if(alu_op == 0b0000): # add
        overflow = (a_sign == b_sign) and (a_sign != r_sign)
        carry = ((a32+b32) >> 32) & 0b1
    elif(alu_op == 0b0001): # sub
        overflow = (a_sign != b_sign) and (a_sign != r_sign)
        carry = ((a + ((~b & 0xFFFFFFFF) +1)) >> 32) & 0b1
    
    return overflow, carry, negative, zero


@cocotb.test()
async def ALU_test(dut):
    ALU_OPS = {
        "ADD":  (0b0000, lambda a,b: a + b),  
        "SUB":  (0b0001, lambda a,b: a - b),  
        "XOR":  (0b0010, lambda a,b: a ^ b),  
        "OR":   (0b0011, lambda a,b: a | b),  
        "AND":  (0b0100, lambda a,b: a & b),  
        "SLL":  (0b0101, lambda a,b: a << (b &0b11111)),  
        "SRL":  (0b0110, lambda a,b: ctypes.c_uint32(a).value >> (b &0b11111)),  
        "SRA":  (0b0111, lambda a,b: ctypes.c_int32(a).value >> (b &0b11111)), 
        "SLT":  (0b1000, lambda a,b: ctypes.c_int32(a).value < ctypes.c_int32(b).value),  
        "SLTU": (0b1001, lambda a,b: ctypes.c_uint32(a).value < ctypes.c_uint32(b).value),  
        "B_PASS": (0b1010, lambda a,b: b),  
    }

    src_values = [
        (5, 3),
        (0xFFFFFFFF, 1),
        (0x7FFFFFFF, 1),
        (0x80000000, 1),
        (1, 2),
        (0, 0),
        (0xFFFFFFFF, 0xFFFFFFFF),
        (0x7FFFFFFF, 0x7FFFFFFF),
        (100, 50),
        (0x12345678, 0x87654321)
    ]

    for values in src_values:
        for operation in ALU_OPS:
            dut.AluOp.value , calculation = ALU_OPS[operation]
            
            dut.SrcA.value = values[0]
            dut.SrcB.value = values[1]

            await Timer(10, unit="ns")

            dut._log.info(f"U{operation} {int(dut.SrcA.value)}, {int(dut.SrcB.value)} result: {int(dut.result.value)}")
            dut._log.info(f"{operation} {int(dut.SrcA.value.to_signed())}, {int(dut.SrcB.value.to_signed())} result: {int(dut.result.value.to_signed())}")

            overflow, carry, negative, zero = calculate_flags(dut.AluOp.value,dut.result.value.to_signed(), values[0],values[1])
            assert(overflow == int(dut.OverflowFlag.value)), "Overflow flag not matched"
            assert(carry == int(dut.CarryFlag.value)), "Carry flag not matched"
            assert(negative == int(dut.NegativeFlag.value)), "Negative flag not matched"
            assert(zero == int(dut.ZeroFlag.value)), "Zero flag not matched"

            expected_result = calculation(int(dut.SrcA.value),int(dut.SrcB.value))
            assert(int(dut.result.value) == (expected_result & 0xFFFFFFFF))


    