riscv64-unknown-elf-as -march=rv32i -mabi=ilp32 test.s -o test.o
riscv64-unknown-elf-ld -m elf32lriscv -T link.ld test.o -o test.elf
riscv64-unknown-elf-objcopy -O verilog test.elf test.hex