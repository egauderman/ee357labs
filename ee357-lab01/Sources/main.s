
// Place static data declarations/directives here
  		.data
// Replace declaration below.
mybuf:	.space 80
mymsg:  .asciz "n=n^2!\n"  // Remember to put and get
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:	
//------- Template Test: Replace Me ----- //
		// Prints welcome message
		movea.l	#mymsg,a1
		jsr		ee357_put_str
		//set up intial values
		move.l	#$1,d2
loop:	//put n^2 into the print register (d1)
		move.l	d2,d1
		mulu.l	d1,d1
		//print register
		jsr		ee357_put_int
		//increment n
		addi.l	#$1,d2
		//check loop condition
		cmpi.l	#10,d2
		bls		loop
		

//======= Let the following few lines always end your main routing ===//		
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //		
inflp:	bra.s	inflp
		rts
		
//------ Defines subroutines here ------- //
//------  Replace sub1 definition ------- //
sub1:	clr.l d0
		rts
