.global _start
_start:
addi s0, x0, 0
addi t0, x0, 10
addi t1, x0, 20

add  t2, t0, t1
sw   t2, 0(s0)

sub  t2, t1, t0
sw   t2, 4(s0)

addi t2, t0, 5
sw   t2, 8(s0)

lui  t2, 1
sw   t2, 12(s0)

auipc t2, 0
sw   t2, 16(s0)

and  t2, t0, t1
sw   t2, 20(s0)

or   t2, t0, t1
sw   t2, 24(s0)

xor  t2, t0, t1
sw   t2, 28(s0)

andi t2, t0, 0xFF
sw   t2, 32(s0)

ori  t2, t0, 0xFF
sw   t2, 36(s0)

xori t2, t0, 0xFF
sw   t2, 40(s0)

sll  t2, t0, t0
sw   t2, 44(s0)

srl  t2, t1, t0
sw   t2, 48(s0)

sra  t2, t1, t0
sw   t2, 52(s0)

slli t2, t0, 2
sw   t2, 56(s0)

srli t2, t0, 1
sw   t2, 60(s0)

srai t2, t0, 1
sw   t2, 64(s0)

slt  t2, t0, t1
sw   t2, 68(s0)

sltu t2, t0, t1
sw   t2, 72(s0)

slti t2, t0, 20
sw   t2, 76(s0)

sltiu t2, t0, 20
sw   t2, 80(s0)

sw   t0, 84(s0)
lw   t2, 84(s0)
sw   t2, 84(s0)

sh   t0, 88(s0)
lh   t2, 88(s0)
sw   t2, 88(s0)

sh   t0, 92(s0)
lhu  t2, 92(s0)
sw   t2, 92(s0)

sb   t0, 96(s0)
lb   t2, 96(s0)
sw   t2, 96(s0)

sb   t0, 100(s0)
lbu  t2, 100(s0)
sw   t2, 100(s0)

addi t3, x0, -1
sb   t3, 104(s0)
lb   t2, 104(s0)
sw   t2, 104(s0)

lbu  t2, 104(s0)
sw   t2, 108(s0)

addi t3, x0, -1
sh   t3, 112(s0)
lh   t2, 112(s0)
sw   t2, 112(s0)

lhu  t2, 112(s0)
sw   t2, 116(s0)

beq  t0, t0, beq_ok
addi t2, x0, 0
jal  x0, beq_done
beq_ok:
addi t2, x0, 1
beq_done:
sw   t2, 120(s0)

bne  t0, t1, bne_ok
addi t2, x0, 0
jal  x0, bne_done
bne_ok:
addi t2, x0, 1
bne_done:
sw   t2, 124(s0)

blt  t0, t1, blt_ok
addi t2, x0, 0
jal  x0, blt_done
blt_ok:
addi t2, x0, 1
blt_done:
sw   t2, 128(s0)

bge  t1, t0, bge_ok
addi t2, x0, 0
jal  x0, bge_done
bge_ok:
addi t2, x0, 1
bge_done:
sw   t2, 132(s0)

bltu t0, t1, bltu_ok
addi t2, x0, 0
jal  x0, bltu_done
bltu_ok:
addi t2, x0, 1
bltu_done:
sw   t2, 136(s0)

bgeu t1, t0, bgeu_ok
addi t2, x0, 0
jal  x0, bgeu_done
bgeu_ok:
addi t2, x0, 1
bgeu_done:
sw   t2, 140(s0)

beq  t0, t1, beq_nt_fail
addi t2, x0, 1
jal  x0, beq_nt_done
beq_nt_fail:
addi t2, x0, 0
beq_nt_done:
sw   t2, 144(s0)

bne  t0, t0, bne_nt_fail
addi t2, x0, 1
jal  x0, bne_nt_done
bne_nt_fail:
addi t2, x0, 0
bne_nt_done:
sw   t2, 148(s0)

blt  t1, t0, blt_nt_fail
addi t2, x0, 1
jal  x0, blt_nt_done
blt_nt_fail:
addi t2, x0, 0
blt_nt_done:
sw   t2, 152(s0)

bge  t0, t1, bge_nt_fail
addi t2, x0, 1
jal  x0, bge_nt_done
bge_nt_fail:
addi t2, x0, 0
bge_nt_done:
sw   t2, 156(s0)

bltu t1, t0, bltu_nt_fail
addi t2, x0, 1
jal  x0, bltu_nt_done
bltu_nt_fail:
addi t2, x0, 0
bltu_nt_done:
sw   t2, 160(s0)

bgeu t0, t1, bgeu_nt_fail
addi t2, x0, 1
jal  x0, bgeu_nt_done
bgeu_nt_fail:
addi t2, x0, 0
bgeu_nt_done:
sw   t2, 164(s0)

jal  ra, jal_target
jal  x0, jal_done
jal_target:
addi t2, x0, 1
sw   t2, 168(s0)
jalr x0, ra, 0
jal_done:

sw   t2, 172(s0)

addi t3, x0, -20
srai t2, t3, 1
sw   t2, 176(s0)

sub  t2, t0, t1
sw   t2, 180(s0)

addi t2, t0, -20
sw   t2, 184(s0)

halt:
jal x0, halt