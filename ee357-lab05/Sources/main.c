/*
 * main implementation: use this sample to create your own application
 *
 */


#include "support_common.h" /* include peripheral declarations and more */
#include "usc_support.h"
#include <stdlib.h>
#if (CONSOLE_IO_SUPPORT || ENABLE_UART_SUPPORT)
/* Standard IO is only possible if Console or UART support is enabled. */
#include <stdio.h>
#endif

void init_gpio()
{
	
	// Init. input buttons that are connected to PortTA
	MCF_GPIO_PTAPAR = 0 
	    | MCF_GPIO_PTAPAR_ICOC0_GPIO
	    | MCF_GPIO_PTAPAR_ICOC1_GPIO;
	/* Set Data Direction to all input */
	MCF_GPIO_DDRTA = 0;
	
    /* Enable 4 LED signals as GPIO */
    MCF_GPIO_PTCPAR = 0
        | MCF_GPIO_PTCPAR_DTIN3_GPIO
        | MCF_GPIO_PTCPAR_DTIN2_GPIO
        | MCF_GPIO_PTCPAR_DTIN1_GPIO
        | MCF_GPIO_PTCPAR_DTIN0_GPIO;
    
    /* Enable signals as digital outputs */
    MCF_GPIO_DDRTC = 0
        | MCF_GPIO_DDRTC_DDRTC3
        | MCF_GPIO_DDRTC_DDRTC2
        | MCF_GPIO_DDRTC_DDRTC1
        | MCF_GPIO_DDRTC_DDRTC0;
	
}

/* Return the value of SW1=TA0 (1=pressed, 0=not pressed) */
int get_SW1_v1()
{
	/* Read the current state of the switch -- remember its active low */
	return (int)(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA0));
}

/* Return the value of SW2=TA1 (1=pressed, 0=not pressed) */
int get_SW3_v1()
{
	/* Read the current state of the switch -- remember its active low */
	return (int)(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA1));	
}

int get_SW1_v2()
{
	int i;
	// Read the current state of the switch 
	if(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA0))
	{
		cpu_pause(5000);
		if(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA0))
		{
		    // Wait until button is released then return 1
			
			return 1;	
		}
	}
	return 0;

}

int get_SW3_v2()
{
	int i;
	/* Read the current state of the switch */
	if(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA1))
	{
		cpu_pause(5000);
		if(!(MCF_GPIO_SETTA & MCF_GPIO_SETTA_SETTA1))
		{
		    // Wait until button is released then return1

			
			return 1;			
		}
	}
	return 0;
}

void leds_display(unsigned char cnt)
{
	MCF_GPIO_PORTTC = cnt;
}



int main(void)
{
	init_gpio();
	
	asm
	{
		// d1 is the incremented value
		// Initialize stuff:
		clr.l	d0
		clr.l	d1
		
		LOOP:
			// Delay the processor
			move.l	#0x7FFFFF, d2
			DELAYLOOP:
				subq.l	#1, d2			// note: keep this #1 so that d2 will definitely get to zero no matter what the initial value of d2 is set to
				bne.s	DELAYLOOP
			
			// Check for interrupts
			jsr		get_SW1_v1		// saves value of SW1 into d0
			move.l	d0, d6
			jsr		get_SW3_v1		// saves value of SW3 into d0
			move.l	d0, d7
			or.l	d6, d0			// check if either of them have been pressed
			beq		SKIPINTERRUPT	// don't handle the interrupt if neither was pressed
			jsr		INTERRUPT
			SKIPINTERRUPT:
			
			// Display d1 on LEDs
			move.b	d1, d0
			jsr		leds_display
			
			// Increment d1 and loop
			addi.l	#3, d1
			bra.s	LOOP
		
		
		INTERRUPT:
			// If SW3 then set d1 to 2
			cmpi.l	#1, d7			// compare #1 and SW3
			bne		SW1INTERRUPT
			move.l	#2, d1
			bra		RETURN
			// If SW1 then check mask bits
			SW1INTERRUPT:
			cmpi.l	#1, d6
			bne		RETURN
			// If mask bits are 1111 don't do anything
			move.b	0x40100044, d0	// put current value of switches N into d0
			lsr.l	#4, d0			// shift d0 4 bits to the right so that the switches' value goes directly to a number
			cmpi.l	#0xF, d0
			beq		RETURN
			// Else set d1 to 1
			move.l	#1, d1
			RETURN:
			rts
	}
}
