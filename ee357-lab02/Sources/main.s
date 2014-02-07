
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

// Outer infinite loop:
// Display even numbers on the LED's.
LOOP1:
	// Inner loop to delay the processor.
	move.l #0xffffff,d2
	LOOP2:
			subq.l #0x1,d2
			bne.s LOOP2

	addq.l #0x2,d1
	move.b d1,0x4010000F // Light up the LED's as the DIP.

	bra.s LOOP1
	
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
