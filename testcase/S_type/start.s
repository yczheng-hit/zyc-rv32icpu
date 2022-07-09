.section .text
/*
8 条
lb
lh
lw
lbu
lhu
sb
sh
sw
*/
start:


# call main
# loop1:
# j loop1
li x1,0x20000010
li x2,0x12345678
li x3,0x9abcdef0

sb x2,0(x1)
sb x3,4(x1)

sh x2,8(x1)
sh x3,12(x1)

sw x2,16(x1)
sw x3,20(x1)

lb x4,0(x1)
lb x5,4(x1)

lh x6,8(x1)
lh x7,12(x1)

lw x8,16(x1)
lw x9,20(x1)

li x2,10
li x3,-10
li x4,1000
li x5,-1000

sw x2,-0x4(x1)
sw x3,-0x8(x1)
sw x4,-0xC(x1)
sw x5,-0x10(x1)

lb x10,-0x4(x1)
lbu x11,-0x8(x1)
lb x12,-0xC(x1)
lbu x13,-0x10(x1)

lh x14,-0x4(x1)
lhu x15,-0x8(x1)
lh x16,-0xC(x1)
lhu x17,-0x10(x1)


.word 0x0000007f