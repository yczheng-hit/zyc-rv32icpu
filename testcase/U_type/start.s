.section .text
/*
2 条
lui
auipc
*/
start:

lui x1,0xffeec
lui x2,0xaabbc 
lui x3,0x11223 

auipc x4,0x11
auipc x5,0x0
auipc x6,0x11
auipc x7,0x0
auipc x8,0x11
auipc x9,0x0

.word 0x0000007f