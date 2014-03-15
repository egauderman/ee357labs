/*
 * main implementation: use this sample to create your own application
 *
 */


#include "support_common.h" /* include peripheral declarations and more */
#include "usc_support.h"
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
int main(void)
{
	int n;
	int i = 0;
	//int counter = 0;
	//unsigned char mycount = 0;

	init_gpio();

  	/*
	while (1){
  		if(get_SW1_v1()){
			mycount++;
  		}
  		if(get_SW3_v1()){		
			mycount--;
  		}
		leds_display(mycount);
  	}
	*/
	
	
	// Wait until sw1 is pressed
	while(!get_SW1_v1()) {}
	while(get_SW1_v1()) {}
	// Get the value on the switches, store to N
	
	
	asm(move.l d1, n);
	//declare int a[N]
	for(int i = 0; i < n; i++)
	{
		// Wait until sw1 is pressed
		while(!get_SW1_v1()) {}
		while(get_SW1_v1()) {}

		// Get the value on the switches, store to a[i]
	}
	//  store to a[i]
	//wait for either sw1 or sw3 to be pressed,
	//  if sw1 sort ascending and display on LEDs
	//  else if sw3 sort descending and display on LEDs
	
	//free the memory used for a?
}
