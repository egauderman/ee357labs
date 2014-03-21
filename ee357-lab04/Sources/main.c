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
		    // Wait until button is released then return1

			
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



asm void sortAscending(int a, int n)
{
	move.l	d0, a0		// put a into register a0
	move.l	d1, d3		// put n into register d0
	
	// note: now, the numbers are in the range: [a7, a7+d3)

	// Bubble Sort:
	// note: i starts at N-1 and goes down to 1, j starts at 0 and goes to N-2.
	//       At each iteration, compare j and j+1 and swap if j>j+1.
	//       On the last iteration of the outer loop, 
	// note: d0 is i, d4 is j, d3 is N, d1 & d2 are temp (?)
	move.l	d3, d0			// move n to d0 (start i as N)
	move.l	#0, d4			// start j at 0
	lsl.l	#2, d0			// mult i by 4

	LOOPI:
		subi.l	#4, d0			// decrement i; now i is pointing to the last element that will be compared. (on first iteration, i=N-1)



		clr.l	d4				// set j to 0
		LOOPJ:
			// Compare [j] with [j+1].  If [j] > [j+1], swap [j] and [j+1].
			move.l	0(a0,d4), d1		// put [j] into d1
			move.l	4(a0,d4), d2		// put [j+1] into d2
			cmp.l	d1, d2				// compare [j] with [j+1]
			bge		NOSWAP				// if d2 ([j+1]) >= d1 ([j]), don't swap.
				// Swap [j] and [j+1].
				move.l	d1, 4(a0,d4) 		// put d1 ([j]) into [j+1]
				move.l	d2, (a0,d4)			// put d2 ([j+1]) into [j]
			NOSWAP:

			addi.l	#4, d4			// increment j
			cmp.l	d0, d4			// compare i and j, and
			bne.s	LOOPJ			// loop back to inner loop if j hasn't reached i

		cmpi.l	#4, d0			// compare i to 1
		bne.s	LOOPI			// go back to outer loop if i hasn't gotten down to 1
	
	rts
}



int main(void)
{
	// Setup
	int n;
	int i = 0;
	int * a;
	int k;

	init_gpio();
	
	
	
	// Wait until sw1 is pressed
	while(!get_SW1_v1()) {}
	while(get_SW1_v1()) {}
	
	// Get the value on the switches, store to n
	asm(clr.l d0);				// clear upper bits of d0
	asm(move.b 0x40100044, d0);	// put current value of switches into d0
	asm(lsr.l #4, d0);			// shift d0 4 bits to the right so that d0 holds the actual value
	asm(move.l d0, n);			// put the number into variable n
	printf("n = %d\n", n);
	
	// Allocate memory for a[n]
	a = (int*) malloc((unsigned long)n*4);
	
	// Iterate through a and get the value for each one
	for(i = 0; i < n; i++)
	{
		// Wait until sw1 is pressed
		while(!get_SW1_v1()) {}
		while(get_SW1_v1()) {}

		// Get the value on the switches, store to a[i]
		asm(clr.l d0);				// clear upper bits of d0
		asm(move.b 0x40100044, d0);	// put current value of switches into d0
		asm(lsr.l #4, d0);			// shift d0 4 bits to the right so that d0 holds the actual value
		asm(move.l d0, k);			// put the number into temp variable k
		a[i] = k;
		printf("a[%d] = %d\n", i, a[i]);
	}
	
	// Wait for either sw1 or sw3 to be pressed, then sort correctly
	while(1)
	{
		if(get_SW1_v1())
		{
			while(get_SW1_v1()) {} // wait for SW1 to be released
			sortAscending((int)a, n);
			printf("After sorting ascending:\n");
			for(i = 0; i < n; i++)
			{
				printf("a[%d] = %d\n", i, a[i]);
			}
		}

		if(get_SW3_v1())
		{
			while(get_SW3_v1()) {} // wait for SW3 to be released
			// Jump to assembly code to sort descending
		}
	}
	//  if sw1 sort ascending and display on LEDs
	//  else if sw3 sort descending and display on LEDs
	
	// Free the memory used for a
	free(a);
}
