.data
/*
** Variabler här
*/
/*
** (((0x3F200000) & 0x00FFFFFF) + (((0x3F200000) >> 4) & 0x0F000000) + 0xF0000000)
*/
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
/*
** Division
*/
getGPIO:
LDR r1, =#0x3F200000
LDR r2, =#0x00FFFFFF
AND r2,r1
LDR r3, =#0x0F000000
LSR r3, #4
ADD r2, r3
LDR r3, =#0x0F000000
ADD r2, r3
LDR r3, =gpio_addr
STR r2, [r3]
bx lr

/*
**(gpio_addr+ (4*(GPIO_NR/10))) |= (1<<(((GPIO_NR)%10)*3));
*/

setOutput:
PUSH{pc, r4}
/*
Laddar in alla variabler på rätt plats så att idiven ger ett korrekt resultat
*/
LDR r2, =gpio_addr
LDR r0, =gpio_output
LDR r1, #10

BL idiv

LDR r3, #4
MUL r3, r0
ADD r3, r2

MOV r2, #3
MUL r2, r1
LSL r2, #1

ORR r1, r3, r2
/*MOV r4, r1*/
POP{lr,r4}

/*
Loopa den övre funktionen i en SEPARAT funktion, ta in ett argument(ladd ain på r0),
och använd argumentet.
Spara unden svaren vi får, för de ska användas senare för att få oss att gråta
Rör inte setOuput(vilket är high läget), då den behövs för avstängning
*/



idiv:
LDR r1, 0x3F200000
ADD gpio_addr, r1
LDR r1, 0x00FFFFFF
ADD gpio_addr, r1

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
POP {pc}
/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:
PUSH {lr}

POP {pc}
