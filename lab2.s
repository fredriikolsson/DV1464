.data
test:
.word 1
.word 3
.word 5
.word 7
.word 9
.word 8
.word 6
.word 4
.word 2
.word 0
textA: .asciz "Lab1 , Assignment  2\n"
textB: .asciz "The max is %d\n"
textC: .asciz "Done\n"
.text
.global  main
.extern  printf
/*******************************************************************
Function :  finding maximum value in a zero terminated integer array
*******************************************************************/
findMax:
PUSH     {lr}
/* Add  code to find  maximum  value  element  here! */
MOV r3, #0

loop:
LDR r2, [r0]
CMP r2, #0
BEQ finnish
CMP r2, r3
BGT newBiggest

ADD r0, r0, #4
BAL loop

newBiggest:
MOV r3, r2
ADD r0, r0, #4
BAL loop

finnish:
MOV r0, r3


/* Any  registers  altered  by the  function  beside r0 -r3 must be  preserved  */
POP      {pc}

/**********************
main  function
**********************/
main:
PUSH     {lr}
LDR      r0 , =textA
BL        printf
LDR      r0 , =test
BL        findMax
MOV      r1 , r0
LDR      r0 , =textB
BL        printf
LDR      r0 , =textC
BL        printf
POP      {pc}
.end
