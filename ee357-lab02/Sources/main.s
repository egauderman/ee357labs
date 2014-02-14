
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
		//
		/* Initialize the LED's. */
		move.l #0x0,d0
		move.b d0,0x4010006F // Set pins to be used GPIO.
		move.l #0xFFFFFFFF,d0
		move.b d0,0x40100027 // Set LED's as output.

		// Initial value 0000 for the LED's:
		move.l #0x0,d1
		move.l d1,0x4010000F
		//initialize previous value of LEDs as 0:
		move.l	#0x0,d3

// Outer infinite loop:
// Display even numbers on the LED's.
LOOP1:
	// Inner loop to delay the processor.
	move.l	#0xffffff,d2
	LOOP2:
		subq.l	#0x1,d2
		bne.s	LOOP2
		
	//check condition with switches
	move.l	#0x40100044, d2		//get input from switches
	cmp.l	#0x1FFFF,d2					//compare against value of switch
	beq.s	FIB					//branch to fib if on	
	
	EVEN:
		move.l	d1,d3			//put current val into predecessor
		addq.l	#0x2,d1			//add two
		move.b	d1,0x4010000F	// Light up the LED's as the DIP.
		bra.s	LOOP1			//restart loop
	FIB:
		move.l	d1,d2			//put current value in temp
		add.l	d3,d1			//add pred and curr
		swap	d1				//mod by 16
		move.b	#0x0,d1
		swap	d1
		move.l	d2,d3			//put temp into pred
		move.b	d1,0x4010000F	// Light up the LED's as the DIP.
		bra.s	LOOP1				//restart loop

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
