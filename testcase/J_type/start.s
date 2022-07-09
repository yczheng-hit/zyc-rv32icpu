.section .text
/*
2 条
jal
jalr
*/

addi x1,x0,0x0
addi x2,x0,0x0
addi x3,x0,0x0
addi x4,x0,0x0
addi x5,x0,0x0
addi x6,x0,0x0
addi x7,x0,0x0
addi x8,x0,0x0
addi x9,x0,0x0

start:
addi x1,x1,0x1
addi x2,x2,0x2
addi x3,x3,0x3

# jal x4,start
# la x5,start
li x5,0x24
jalr x4,x5
end:


.word 0x0000007f