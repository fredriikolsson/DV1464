.data
/*
** Variabler här
*/
/*
** (((0x3F200000) & 0x00FFFFFF) + (((0x3F200000) >> 4) & 0x0F000000) + 0xF0000000)
*/
text: .asciz "OutputValue: %x\n"

gpio_addr: .word 0

gpio_output:
.word 17
.word 18
.word 27
.word 22
gpio_input:
.word 10
.word 9


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

bx lr

/*
**(gpio_addr+ (4*(GPIO_NR/10))) |= (1<<(((GPIO_NR)%10)*3));
*/
/*
** OUTPUT FUNCTIONS ************************************************************
*/
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

/*
** INPUT FUNCTIONS *************************************************************
*/
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
BL setOutput
CMP r5, #2
BNE loopI

POP {r4, r5, pc}

/*
** HIGH FUNCTION ***************************************************************
*/

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


/*
** LOW FUNCTION ***************************************************************
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


/*
** Short wait
*/

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
Loopa den övre funktionen i en SEPARAT funktion, ta in ett argument(ladda in på r0),
och använd argumentet.
Spara undan svaren vi får (genom att pusha och poppa register), för de ska användas senare för att få oss att gråta
Rör inte setOutput(vilket är
gh läget), då den behövs för avstängning
*/


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
POP {pc}
/*
** Avbrottsrutin som kallas när ett avbrott sker. Ska räkna neråt
*/
.GLOBAL counter_isr_down
counter_isr_down:
PUSH {lr}
POP {pc}
/*
 * Sätt upp åtkomst till GPIO-pinnarnas minne
 */
.GLOBAL setup
setup:
PUSH {lr}

BL getGPIO

BL outputLoop

BL highLoop

BL inputLoop


/*
** SET PULLUP loop för båda knapparna
*/


POP {pc}
/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:
PUSH {lr}
/*
	ALLT FÖR AVSLUT SET PULL till 0 efter lowLoop
*/
BL lowLoop

POP {pc}
