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
// The number after .ds.l should be the number of desired instructions, not including the END instruction (program automaticaly adds an END instruction)
CODE:	.ds.l 11
				
  		.text
		.global _main
		.global main
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

_main:
main:	
	// Initialize the LED's
	move.b 	#0x0,d0
	move.b 	d0,0x4010006F // Set pins to be used GPIO
	move.b 	#0xFFFFFFFF,d0
	move.b 	d0,0x40100027 // Set LED's as output

	// Initial value 0000 for the LED's
	move.b 	#0x0,d1
	move.b 	d1,0x4010000F
	
	// Initialize the Switches
	move.b 	#0x0F,d0
	move.b 	d0,0x40100074 // Set pins to be used GPIO
	move.b 	d0,0x4010002C // Set Switches as input



	move.l 	#CODE, a0 // start a0 at the location in which to load the instructions
	// Load program one instruction at a time into memory
	// Change these lines to change the program
	move.l 	#%00001000000100000000000000001111, (a0)+
	move.l 	#%00000100000001000000000000000000, (a0)+
	move.l 	#%00000100000011000000000000000000, (a0)+
	move.l 	#%11000011000000000000000000000000, (a0)+
	move.l 	#%00001000010000000000000000001010, (a0)+
	move.l 	#%00010010011000000000000000001000, (a0)+
	move.l 	#%00000101011001000000000000000000, (a0)+
	move.l 	#%00100000100100000000000000000001, (a0)+
	move.l 	#%00011000000111111111111111110100, (a0)+
	move.l 	#%10000001000000000000000000000001, (a0)+
	move.l 	#%00000000100100000000000000000001, (a0)+
	
	// Init program counter
	move.l	#CODE, a0
	move.l	a0, PPC
	
	// Main processing loop
	main_loop:
		// 1) load instruction at PPC
		move.l	PPC, a0
		
		// 2a) determine OPCODE
		move.l	(a0), d0
		move.l	d0, d1
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



//====================================//
//============= COMMANDS =============//
//====================================//

ADD:	clr.l 	d1
		
		//TODO Eric will do this
		
		bra		main_loop_return
	
		
ADDI:	clr.l 	d1

		move.l	d0, d1	// retrieve code again to obtain operands
		andi.l	#$000FFFFF, d1	// obtain immediate value
		move.l	d1, d2		// d2 = #Imm
		
		move.l	d0, d1	// retrieve code again to obtain operands
		lsr.l	#8, d1
		lsr.l	#8, d1
		lsr.l	#4, d1
		andi.l	#%111, d1
		move.l	d1, d3		// d3 = rt (register index)
		
		move.l	d0, d1	// retrieve code again to obtain operands
		lsr.l	#8, d1
		lsr.l	#8, d1
		lsr.l	#7, d1
		andi.l	#%111, d1
		move.l	d1, d4		// d4 = rs (register index)
		
		muls.w	#4, d3		// multiply offset by 4
		move.l	d3, a1		// load a1 with address (e.g. 000)
		add.l	#R0, a1		// d5 = address of the register for rt
		
		muls.w	#4, d4		// multiply offset by 4
		move.l	d4, a2		// load a2 with address (e.g. 001)
		add.l	#R0, a2		// d6 = address of the register for rs
		
		// TODO: a1 and a2 have the correct addresses of rt and rs (e.g., R1 and R0)
		// Now the sum of the immediate value and the value at rt must be moved to rs
		add.l	(a1), (a2)
		
		// Result: rs = rt + #Imm
		
		bra		main_loop_return
		

LOAD:	// TODO: complete LOAD command
		

		bra		main_loop_return


BE:		clr.l 	d1
		//retrieve rt = a1, bits 7-9 (index 1), shift 23
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#7,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a1
		//retrieve rs = a2, bits 10-12, shift 20
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#4,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a2
		//retrieve #imm = d2, bits 13-32, shit none
		move.l	d0,d1
		andi.l	#$FFFFF,d1
		move.l	d1,d2
		
		move.l	(a1),d4			//d4 contains value in rt
		move.l	(a2),d5			//d5 contains value in rs
		cmp.l	d4,d5
		beq		eq				//if they are equal, incr PPC. else return.
		bra		main_loop_return
	eq:	add.l	d2,a0			//add imm to PPC
		move.l	a0,PPC
		bra		main_loop		//we do not want to increment PPC again


BNE:	clr.l 	d1
		//retrieve rt = a1, bits 7-9 (index 1), shift 23
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#7,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a1
		//retrieve rs = a2, bits 10-12, shift 20
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#4,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a2
		//retrieve #imm = d2, bits 13-32, shit none
		move.l	d0,d1
		andi.l	#$FFFFF,d1
		move.l	d1,d2
		
		move.l	(a1),d4			//d4 contains value in rt
		move.l	(a2),d5			//d5 contains value in rs
		cmp.l	d4,d5
		bne		neq				//if they are not equal, incr PPC. else return.
		bra		main_loop_return
	neq:add.l	d2,a0			//add imm to PPC
		move.l	a0,PPC
		bra		main_loop		//we do not want to increment PPC again


SUBI:	clr.l 	d1
		//retrieve rt = a1, bits 7-9 (index 1), shift 23
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#7,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a1
		//retrieve rs = a2, bits 10-12, shift 20
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#4,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a2
		//retrieve #imm = d2, bits 13-32, shit none
		move.l	d0,d1
		andi.l	#$FFFFF,d1
		move.l	d1,d2
		
		move.l	(a2),d3			//d3 holds value of rs
		sub.l	d2,d3			//d3 - d2 (rs - #imm)
		move.l	d3,(a1)			//move value into rt (a1)
		
		bra		main_loop_return


READS:	clr.l 	d1
		//retrieve rt = a1, bits 7-9 (index 1), shift 23
		move.l	d0,d1
		lsr.l	#8,d1
		lsr.l	#8,d1
		lsr.l	#7,d1
		andi.l	#%111,d1
		lsl.l	#2,d1			//multiply by 4
		move.l	R0,a1
		move.l	0(a1,d1),a1
		//get value from switches into d2
		move.b	$40100044, d2
		lsr.l	#4, d2			//shift d2 right 4 bits so that the switches represent a number
		move.l	d2,(a1)			//move value of switches into rt
		bra		main_loop_return


// Display value of given register on LEDs
DIS:	move.l	d0, d1		// Copy command into d1
		lsr.l	#8, d1		// Shift by 23 bits to remove unused bits in DIS command
		lsr.l	#8, d1
		lsr.l	#7, d1
		andi.l	#%111, d1	// AND with 111 to retrieve only the 3 lower-order bits (corresponds to the given register)
		
		move.l	d1, d2		// Get the value of the given register and place into d2
		jsr		GET_REG_D2
		
		move.b 	d2, 0x4010000F	// Light up LED's with value of d2 (which is the value of the given register)

		bra		main_loop_return


// END command that causes program to hang with nothing else to do
END:	move.b 	#0xFF, d1		// Light up LED's with 1111
		move.b 	d1, 0x4010000F
		bra		inflp			// Loop forever



//=====================================//
//========== HELPER ROUTINES ==========//
//=====================================//

// Precondition: put register number in d2 (000 through 111 inclusive)
// Result: The value in given register will be in d2
// Note: Does not clobber anything
GET_REG_D2:
		move.l	a1, -(a7)		// push a1's old value onto the stack to avoid clobbering (a7 is SP)
		
		lsl.l	#2, d2			// Multiply by 4
		move.l	#R0, a1			// Move address of R0 into a1
		move.l	(a1,d2), d2		// Offset R0 by d2 and put the value of this new address into d2
		
		move.l	(a7)+, a1		// pop the stack to put back the old value of a1
		rts

// Precondition: put register number in d3 (000 through 111 inclusive) and the desired value in d2
// Result: The value in the register number passed in through d3 will be set to whatever's in d2
// Note: Does not clobber anything. d2 and d3 will not be affected either.
SAVE_D2_TO_REG_D3:
		move.l	a1, -(a7)		// push a1's old value onto the stack to avoid clobbering (a7 is SP)
		
		lsl.l	#2, d3			// multiply d3 by 4
		move.l	#R0, a1			// Start a1 at address of R0
		move.l	d2, (a1,d3)		// Offset R0 by d3 and put the value in d2 into that location
		lsr.l	#2, d3			// un-multiply d3 by 4
		
		move.l	(a7)+, a1		// pop the stack to put back the old value of a1
		rts

// Subroutine for waiting so user can see LED output
// Note: Change #0x5FFFFF to make waiting period longer/shorter
// Note: Does not clobber anything
WAIT:
		move.l	d2, -(a7)		// push d2's value onto the stack to avoid clobbering (a7 is SP)
		
		move.l	#0x5FFFFF, d2	// initialize counter
	
	WAIT_LOOP:
			subq.l	#0x1, d2	// decrement counter by 1
			bne.s 	WAIT_LOOP	// loop until counter reaches 0
		
		move.l	(a7)+, d2		// pop the stack to restore value of d2
		rts
