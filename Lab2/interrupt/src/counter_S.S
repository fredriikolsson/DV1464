.data
/*
** Variabler här
*/
btnOne: .asciz "Knapp 1\n"
btnTwo: .asciz "Knapp 2\n"
counterText: .asciz "Counter number: %x\n"

gpio_addr: .word 0

counter: .word 1

gpio_output:
.word 17
.word 18
.word 27
.word 22
gpio_input:
.word 9
.word 8

.text

getGPIO:
/*LDR r1, 0x3F200000
ADD gpio_addr, r1
LDR r1, 0x00FFFFFF
ADD gpio_addr, r1
*/
LDR r1, =#0x3F200000
LDR r2, =#0x00FFFFFF
AND r2,r1
LDR r3, =#0x0F000000
LSR r1, #4
AND r3, r1
LDR r1, =#0xF0000000
ADD r1, r3
ADD r2, r1
LDR r3, =gpio_addr
STR r2, [r3]
LDR r2, =gpio_addr

bx lr

setOutput:
PUSH {lr}
/*
Laddar in alla variabler på rätt plats så att idiven ger ett korrekt resultat
*/
LDR r2, =gpio_addr
LDR r2, [r2]
MOV r1, #10

PUSH {r2}
BL idiv
POP {r2}

MOV r3, #4
MUL r3, r0
ADD r3, r2

MOV r2, #3
MUL r2, r1
MOV r1, #1
LSL r1, r2
/*
SKRIV UT r1 och r3
*/
LDR r0, [r3]
ORR r1, r0, r1
STR r1, [r3]
/*MOV r4, r1*/
POP {pc}


outputLoop:
PUSH {r4, r5, lr}

LDR r4, =gpio_output
MOV r5, #0
loopO:
LDR r0, [r4, r5, LSL #2]
ADD r5, #1
BL setOutput
CMP r5, #4
BNE loopO

POP {r4, r5, pc}

setInput:
PUSH {lr}
/*
Laddar in alla variabler på rätt plats så att idiven ger ett korrekt resultat
*/
LDR r2, =gpio_addr
LDR r2, [r2]
MOV r1, #10

PUSH {r2}
BL idiv
POP {r2}

MOV r3, #4
MUL r3, r0
ADD r3, r2

MOV r2, #3
MUL r2, r1
MOV r1, #7
LSL r1, r2

MVN r1, r1

LDR r0, [r3]
AND r1, r0, r1
STR r1, [r3]
/*MOV r4, r1*/
POP {pc}


inputLoop:
PUSH {r4, r5, lr}

LDR r4, =gpio_input

MOV r5, #0

loopI:
LDR r0, [r4, r5, LSL #2]
ADD r5, #1
BL setInput
CMP r5, #2
BNE loopI

POP {r4, r5, pc}

setPullUp:
PUSH {lr}

LDR r2, =gpio_addr
LDR r2, [r2]

ADD r2, #148
MOV r0, #2
STR r0, [r2]

BL shortWait

POP {pc}

setPullDown:
PUSH {lr}

/*
LDR r0, =text

BL printk
*/
LDR r2, =gpio_addr
LDR r2, [r2]

ADD r2, #148
MOV r0, #1
STR r0, [r2]

BL shortWait

POP {pc}

pinPullUp:
PUSH {lr}

MOV r1, #32

PUSH {r2}
BL idiv
POP {r2}

LDR r2, =gpio_addr
LDR r2, [r2]
ADD r2, #152

MOV r3, #1
LSL r3, r1

STR r3, [r2]
BL shortWait
POP {pc}

pinPullUpLoop:
PUSH {r4, r5, lr}

/*
** Byter från output till input och ändrar CMP till 2 istället för 4
*/
LDR r4, =gpio_input
MOV r5, #0

loopUp:
LDR r0, [r4, r5, LSL #2]
ADD r5, #1
BL pinPullUp
CMP r5, #2
BNE loopUp

POP {r4, r5, pc}

setReset:
PUSH {lr}

LDR r2, =gpio_addr
LDR r2, [r2]

ADD r2, #148
MOV r0, #0
STR r0, [r2]

LDR r2, =gpio_addr
LDR r2, [r2]

ADD r2, #152
MOV r0, #0
STR r0, [r2]

BL shortWait

POP {pc}

/*
** För att stänga av lamporna i setdown
*/

outputLow:
PUSH {lr}
/*
Laddar in alla variabler på rätt plats så att idiven ger ett korrekt resultat
*/
LDR r2, =gpio_addr
LDR r2, [r2]
MOV r1, #32

PUSH {r2}
BL idiv
POP {r2}

MOV r3, #4
ADD r0, #10
MUL r3, r0
ADD r3, r2

MOV r2, #1
LSL r2, r1

LDR r0, [r3]
STR r2, [r3]

POP {pc}

lowLoop:
PUSH {r4, r5, lr}

LDR r4, =gpio_output
MOV r5, #0
loopL:
LDR r0, [r4, r5, LSL #2]
ADD r5, #1
BL outputLow
CMP r5, #4
BNE loopL

POP {r4, r5, pc}


outputHigh:
PUSH {lr}
/*
Laddar in alla variabler på rätt plats så att idiven ger ett korrekt resultat
*/
LDR r2, =gpio_addr
LDR r2, [r2]
MOV r1, #32

PUSH {r2}
BL idiv
POP {r2}

MOV r3, #4
ADD r0, #7
MUL r3, r0
ADD r3, r2

MOV r2, #1
LSL r2, r1

/*
LDR r0, =text
PUSH {r1, r3}
MOV r1, r2
BL printk
POP {r1, r3}
*/

LDR r0, [r3]
STR r2, [r3]

POP {pc}

highLoop:
PUSH {r4, r5, lr}

LDR r4, =gpio_output
MOV r5, #0
loopH:
LDR r0, [r4, r5, LSL #2]
ADD r5, #1
BL outputHigh
CMP r5, #4
BNE loopH

POP {r4, r5, pc}

shortWait:
PUSH {lr}

MOV r1, #1
waitLoop:
ADD r1, #1
SUB r1, #1
ADD r1, #1
CMP r1, #150
BNE waitLoop

POP {pc}
/*
** Division
*/
idiv:
	/* r0 innehåller N */
	/* r1 innehåller D */
	mov r2, r1
	mov r1, r0
	mov r0, #0
	b .Lloop_check
	.Lloop:
		add r0, r0, #1
		sub r1, r1, r2
	.Lloop_check:
		cmp r1, r2
		bhs .Lloop
	/* r0 innehåller kvoten */
	/* r1 innehåller resten */
	bx lr

/*
** Avbrottsrutin som kallas när ett interrupt sker. Ska räkna uppåt
*/
.GLOBAL counter_isr_up
counter_isr_up:
PUSH {lr}
/*
** Avbrottsrutin som kallas när ett avbrott sker. Ska räkna neråt
*/
LDR r2, =counter
LDR r0, [r2]
ADD r0, #1

CMP r0, #16
MOVEQ r0, #1
STR r0, [r2]



POP {pc}
.GLOBAL counter_isr_down
counter_isr_down:
PUSH {lr}
/*
 * Sätt upp åtkomst till GPIO-pinnarnas minne
 */
 LDR r2, =counter
 LDR r0, [r2]
 SUB r0, #1

 CMP r0, #0
 MOVEQ r0, #15
 STR r0, [r2]

POP {pc}
.GLOBAL setup
setup:
PUSH {lr}

BL getGPIO

BL outputLoop
BL inputLoop

BL highLoop

BL setPullUp
BL pinPullUpLoop

/*
** Ta bort åtkomst till GPIO
*/
POP {pc}
.GLOBAL setdown
setdown:
PUSH {lr}

BL lowLoop
BL setReset

POP {pc}
