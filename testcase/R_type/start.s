.section .text

/*
10 条
add
sub
sll
slt
sltu
xor
srl
sra
or
and
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

addi x1, zero, 0x1
addi x2, zero, 0x2
addi x3, zero, 0x3
addi x4, zero, 0x4
addi x5, zero, 0x5

# add
add x6, x1, x1
add x7, x2, x2
add x8, x3, x3
add x9, x4, x4
add x10, x5, x5
add x6, x1, x1
add x7, x2, x2
add x8, x3, x3
add x9, x4, x4
add x10, x5, x5
add x6, x1, x1
add x7, x2, x2
add x8, x3, x3
add x9, x4, x4
add x10, x5, x5

# sub
sub x11, x6, x1
sub x12, x7, x2
sub x13, x8, x3
sub x14, x9, x4
sub x15, x10, x5
# sll
sll x16,x1,x1
sll x17,x2,x2
# slt TODO: add signed num
slt x18,x6,x1
slt x19,x2,x7
# sltu
sltu x20,x1,x6
sltu x21,x7,x2
# xor
xor x22,x6,x6
xor x23,x6,x1
# srl 
srl x24,x6,x1
srl x25,x6,x2
# sra TODO:
sra x26,x6,x1
sra x27,x6,x2
# or
or x28,x1,x6
or x29,x2,x7
# and
and x30,x1,x6
and x31,x2,x7


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

#signed data test
addi x1,zero,-0x8
addi x2,zero,0x8
addi x3,zero,-0x10
addi x4,zero,0x10
addi x5,zero,1

# slt
slt x6,x1,x2
slt x7,x3,x2
# srl 
srl x8,x1,x5
srl x9,x2,x5
srl x10,x3,x5
srl x11,x4,x5
# sra 
sra x12,x1,x5
sra x13,x2,x5
sra x14,x3,x5
sra x15,x4,x5
# .word 0x0000007f
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

# TODO: data overflow test
lui	ra,0xaabbd
addi	ra,ra,-803
li x1,-0xaabbccdd
li x2,0xaabbccdd
li x3,-0xff000000
li x4,0xff000000
addi x5,zero,1
# slt
slt x6,x1,x2
slt x7,x3,x2
# srl 
srl x8,x1,x5
srl x9,x2,x5
srl x10,x3,x5
srl x11,x4,x5
# sra 
sra x12,x1,x5
sra x13,x2,x5
sra x14,x3,x5
sra x15,x4,x5

# add
add x16,x1,x1
add x17,x2,x2

.word 0x0000007f