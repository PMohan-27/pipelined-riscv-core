.global _start
_start:
    lui  t2, 1
    auipc t2, 0
    addi t0, x0, 10
    addi t1, x0, 20
    sub  t2, t1, t0   # should be 10
halt:
    jal x0, halt