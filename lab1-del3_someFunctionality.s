.data

factorialNumber: .word 10

textA: .asciz "Lab1 , Assignment  3\n"
textB: .asciz "Factorial of 1 - 10 is %d\n"
textC: .asciz "Done\n"
.text
.global main
.extern printf

/*******************************************************************
Function :  finding maximum value in a zero terminated integer array
*******************************************************************/
 factorial:
 PUSH {lr}
 /*LDR r2, [r0]*/
 /* CMP r2, #10
 BEQ base */
 CMP r2, #0
 BEQ finnish

 MUL r1, r2
 SUB r2, #1
 BAL factorial

 /* base:
 LDR      r1, #1
 */
 finnish:
 MOV r0, r1
 POP {pc}


 /**********************
 main  function
 **********************/
main:
PUSH {lr}
LDR      r0 , =textA
BL        printf
LDR      r0, =factorialNumber
LDR      r2, [r0]
MOV      r1, #1
BL        factorial
MOV      r1 , r0
LDR      r0 , =textB
BL        printf
LDR      r0 , =textC
BL        printf
POP {pc}
.end
