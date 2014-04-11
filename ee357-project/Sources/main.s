  		.data
PPC:	.ds.l 1		// Program Counter
R0:		.ds.l 1		// 8 Registers
R1:		.ds.l 1
R2:		.ds.l 1
R3:		.ds.l 1
R4:		.ds.l 1
R5:		.ds.l 1
R6:		.ds.l 1
R7:		.ds.l 1

// Reserve space for 11 32-bit instructions in memory
// Change this line to support more/less instructions
CODE:	.ds.l 11

// Always ends the program
// Do not remove
ENDLOC:	.ds.l 1
				
  		.text
		.global _main
		.global main
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:	
	// Load program one instruction at a time into memory
	// Change these lines to change the program
	move.l 	#CODE, a0
	move.l 	#%00001000000100000000000000001111, (a0)+
	move.l 	#%00000100000001000000000000000000, (a0)+
	move.l 	#%00000100000011000000000000000000, (a0)+
	move.l 	#%11000011000000000000000000000000, (a0)+
	move.l 	#%00001000010000000000000000001010, (a0)+
	move.l 	#%00010010110000000000000000001000, (a0)+
	move.l 	#%00000111001001000000000000000000, (a0)+
	move.l 	#%00100000100100000000000000000001, (a0)+
	move.l 	#%00011000000100001111111111111000, (a0)+
	move.l 	#%10000001000000001111111111111000, (a0)+
	move.l 	#%00100000100100000000000000000001, (a0)+
	
	// Load END instruction to memory
	// Do not remove this
	move.l 	#%00000000000000000000000000000000, (a0)+
	
	// Init program counter
	move.l	#CODE, a0
	move.l	a0, PPC
	
	// Main processing loop
	main_loop:
		// 1) load instruction at PPC
		move.l	PPC, a0
		
		// 2a) determine OPCODE
		move.l	(a0), d1
		lsr.l	#8, d1
		lsr.l	#8, d1
		lsr.l	#8, d1
		lsr.l	#2, d1
		
		// 2b) branch to subroutine that handles specific OPCODE	
		// 2c) load operands
		// 2d) execute instruction
		cmpi.l	#%000001, d1	// ADD
		beq		ADD
		
		cmpi.l	#%000010, d1	// ADDI
		beq		ADDI
		
		cmpi.l	#%000011, d1	// LOAD
		beq		LOAD
		
		cmpi.l	#%000100, d1	// BE
		beq		BE
		
		cmpi.l	#%000110, d1	// BNE
		beq		BNE
		
		cmpi.l	#%001000, d1	// SUBI
		beq		SUBI
		
		cmpi.l	#%110000, d1	// READS
		beq		READS
		
		cmpi.l	#%100000, d1	// DIS
		beq		DIS
		
		cmpi.l	#%000000, d1	// END
		beq		END
		
	main_loop_return:
		// 3) increment PPC 
		addq.l	#4,a0
		move.l	a0,PPC
		
		// Continue main loop
		bra		main_loop

//======= Let the following few lines always end your main routing ===//		
//------- No OS to return to so loop ---- //
//------- infinitely...Never hits rts --- //		
inflp:	bra.s	inflp
		rts
		
//------ Defines subroutines here ------- //
//------  Replace sub1 definition ------- //
ADD:	clr.l 	d0
		bra		main_loop_return
	
		
ADDI:	clr.l 	d0
		bra		main_loop_return
		

LOAD:	clr.l 	d0
		bra		main_loop_return


BE:	clr.l 	d0
		bra		main_loop_return


BNE:	clr.l 	d0
		bra		main_loop_return


SUBI:	clr.l 	d0
		bra		main_loop_return


READS:	clr.l 	d0
		bra		main_loop_return


DIS:	clr.l 	d0
		bra		main_loop_return


END:	clr.l 	d0
		bra		inflp

