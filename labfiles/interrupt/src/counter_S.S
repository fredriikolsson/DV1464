.data
/*
** Variabler här
*/

gpio_addr: .word (((0x3F200000) & 0x00FFFFFF) + (((0x3F200000) >> 4) & 0x0F000000) + 0xF0000000)


.text
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

POP {pc}
/*
** Ta bort åtkomst till GPIO
*/
.GLOBAL setdown
setdown:
PUSH {lr}

POP {pc}
