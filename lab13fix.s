.data

textA: .asciz "Lab1 , Assignment  3\n"
textB: .asciz "Factorial of %d is %d\n"
.text
.global main
.extern printf

/*******************************************************************
Function :  finding maximum value in a zero terminated integer array
*******************************************************************/
 factorial:
 PUSH {lr}
 MOV r6, r0
 CMP r6, #0
 BEQ base

 CMP r6, #11
 BEQ finnish

 MOV r0, r6
 MOV r1, r5
 BL print
 ADD r6, #1
 MUL r5, r6
 MOV r0, r6

 BAL recursive

 base:
 MOV r5, #1
 MOV r0, r6
 MOV r1, r5
 BL print
 ADD r6, #1
 MOV r0, r5

 recursive:
 BL factorial

 finnish:
 MOV r0, r5
 POP {pc}






 print:
 PUSH {lr}
 MOV r2, r1
 MOV r1, r0
 LDR r0, =textB
 BL printf
 POP {pc}


 /**********************
 main  function
 **********************/
main:
PUSH {lr}
LDR      r0 , =textA
BL        printf
MOV r0, #0
BL        factorial
POP {pc}
.end
