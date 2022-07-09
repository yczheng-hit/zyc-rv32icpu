.section .text
/*
9 条
ld 和 st 在一起
addi
slti
sltiu
xori
ori
andi
slli
srli
srai
*/
start:

# call main
# loop1:
# j loop1
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

# addi
addi x1, zero, 0x1
addi x2, zero, 0x2
addi x3, zero, 0x3
addi x4, zero, 0x4
addi x5, zero, 0x5

# slti
slti x6,x1,0x3
slti x7,x5,0x3
slti x8,x5,-0x3

# sltiu
sltiu x9,x1,0x3
sltiu x10,x5,0x3
sltiu x11,x5,-0x3


# xori
xori x12,x1,0x10
xori x13,x2,0x12


# ori
ori x14,x1,0x84
ori x15,x2,0x74



# andi
andi x12,x1,0x10
andi x13,x2,0x12


addi x14, zero, -0x100
addi x15, zero, 0x100
# slli
slli x16,x14,1
slli x17,x14,2
slli x18,x15,1

# srli
slli x19,x14,1
slli x20,x14,2
slli x21,x15,1


# srai
slli x22,x14,1
slli x23,x14,2
slli x24,x15,1



.word 0x0000007f