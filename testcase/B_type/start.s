.section .text
/*
6 条
beq
bne
blt
bltu
bge
bgeu
*/
start:
addi x1, zero, 0
addi x2, zero, 0
addi x3, zero, 0
addi x4, zero, 0
addi x5, zero, 0
addi x6, zero, 0
addi x7, zero, 0
addi x8, zero, 0
addi x9, zero, 0
addi x10, zero, 0
addi x11, zero, 0
addi x12, zero, 0
addi x13, zero, 0
addi x14, zero, 0
addi x15, zero, 0
addi x16, zero, 0
addi x17, zero, 0
addi x18, zero, 0
addi x19, zero, 0
addi x20, zero, 0
addi x21, zero, 0
addi x22, zero, 0
addi x23, zero, 0
addi x24, zero, 0
addi x25, zero, 0
addi x26, zero, 0
addi x27, zero, 0
addi x28, zero, 0
addi x29, zero, 0
addi x30, zero, 0
addi x31, zero, 0

addi x1,x1,0x1
again1:
addi x2,x2,0x1
addi x3,x3,0x3

bne x1,x2,run1
beq x1,x2,again1

run1:

addi x5,x5,-0x3
again2:
addi x4,x4,-0x1

bge x4,x5,again2

addi x6,x6,-0x3
again3:
addi x7,x7,-0x1

blt x6,x7,again3

addi x8,x8,0x3
again4:
addi x9,x9,0x1

bgeu x8,x9,again4

addi x10,x10,0x3
again5:
addi x11,x11,0x1

bltu x11,x10,again5

addi x12,x12,-0x13
addi x13,x13,-0x11
again6:
addi x12,x12,1

bgeu x13,x12,again6

addi x14,x14,-0x13
addi x15,x15,-0x11
again7:
addi x14,x14,0x1

bltu x14,x15,again7


.word 0x0000007f