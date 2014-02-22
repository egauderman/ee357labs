
// Place static data declarations/directives here
  		.data
// Replace declaration below.
mybuf:	.space 80
mymsg:  .asciz "ASM template for EE 357\n"  // Remember to put and get
prmpt0: .asciz "Here is an integer:\n"		// strings terminated with
prmpt1: .asciz "Enter a string:\n"          // newline characters
prmpt2: .asciz "Enter an integer:\n"
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

//d1 holds LED value
//d2 used to delay processor and as a temp for switches and fib nums
//d3 holds previous value
//d4 is a temp register for switches and fib processing

_main:
main:
		// IO settings for LEDs and switches:
		// Port Assignment (GPIO mode, whatever that means):
		move.l #$0, d0
		move.b d0, $4010006F	// Set pins for LEDs port to GPIO mode.
		move.b d0, $40100074	// Set pins for switches port to GPIO mode.
		// Data Direction:
		// move.b #$0, d0		//already done above
		move.b d0, $4010002C	// Set switches as input.
		move.b #$FF, d0
		move.b d0, $40100027	// Set LEDs as output.

		// Initialize the value of current value of the sequence (and the LEDs):
		move.b #$0, d1
		move.b d1, $4010000F
		
		move.l	#$1, d3 // initialize previous value of the sequence as 1
		
		// note: move values into $4010000F to set LEDs,
		//       and move values from $40100044 to get input from switches.
		
		

// Outer infinite loop:
// Display even numbers on the LED's.
SEQUENCELOOP:
	// Inner loop to delay the processor.
	move.l	#$7FFFFF, d2
	DELAYLOOP:
		subq.l	#$1, d2			// note: keep this #0x1 so that d2 will definitely get to zero no matter what the initial value of d2 is set to
		bne.s	DELAYLOOP
	
	//check condition with switches
	move.l	#$0, d2				//clear d2 (because we can only compare with size long)
	move.b	$40100044, d2		//get input from switches
	lsr.l	#4, d2				//shift d2 right 4 bits so that the switches represent a number
	cmpi.l	#$0, d2				//check if any of the switches are on
	bne.s	FIB					//branch to fib if any of the four switches is on (if 0xF is less than d2)
	
	EVEN:
		move.l	d1, d3			//put current val into predecessor so that we have it if we switch to fib
		addq.l	#2, d1			//add two
		bra.s	AFTER			//skip the fib section to update the LEDs and loop
	FIB:
		// note: d1 is current, d3 is previous, d2 is temp
		move.l	d1, d2			//put current value in temp
		add.l	d3, d1			//add predecessor into current
		move.l	d2, d3			//put temp into predecessor
	AFTER:
		move.b	d1, $4010000F	// light up the LED's as the DIP.
		jsr		ee357_put_int	//print current value of sequence
		bra.s	SEQUENCELOOP	//restart loop

/* bcc.l and bra.l are not supported (supported only ISA_B);
 * use only bcc.s, bcc.w, bra.s or bra.w.
 */


//======= Let the following few lines always end your main routing ===//
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //
inflp:	bra.s	inflp
		rts

//------ Defines subroutines here ------- //
//------  Replace sub1 definition ------- //
sub1:	clr.l d0
		rts
