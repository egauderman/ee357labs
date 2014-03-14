// Place static data declarations/directives here
  		.data
// Replace declaration below.
mybuf:	.space 80
mymsg:  .asciz "EE-357 Lab 3\n"  // Remember to put and get
prmpt0: .asciz "Here is an integer:\n"		// strings terminated with
prmpt1: .asciz "Enter a string:\n"          // newline characters
prmpt2: .asciz "Enter an integer:\n"
  		.text
		.global _main
		.global main
		.global mydat
		.include "../Project_Headers/ee357_asm_lib_hdr.s"

/* bcc.l and bra.l are not supported (supported only ISA_B);
 * use only bcc.s, bcc.w, bra.s or bra.w.
 */

//d1 holds LED value
//d2 used to delay processor and as a temp for switches and fib nums
//d3 holds previous value
//d4 is a temp register for switches and fib processing

_main:
main:
	jsr initio				// initialize IO stuffs
	// note: move values into $4010000F to set LEDs,
	//       and move values from $40100044 to get input from switches.



	// Initialize N.
	// note: d0 is counter, d3 saves N
	clr.l	d0				// clear upper bits of d0
	move.b	$40100044, d0	// put current value of switches N into d0
	lsr.l	#4, d0			// shift d0 4 bits to the right so that the switches' value goes directly to a number
	move.l	d0, d1			// put N into d1 so we can print it
	jsr		ee357_put_int	// print the last entered value
	clr.l	d3				// clear upper bits of d3
	move.b	d0, d3			// copy N into d3



	// Get list of numbers.
	INPUTLOOP:
		subi.l	#1, d0			// decrement counter

		jsr		getinput		// put the next value into d1
		jsr		ee357_put_int	// print the last entered value
		move.b	d1, $4010000F	// light up the LEDs with the current value
		move.l	d1, -(a7)		// put it on the stack
//		move.l	(a7), d1		// move the value into d1 so we can print
//		jsr		ee357_put_int	// print it

		cmpi.l	#0, d0			// if we haven't finished all the values,
		bne.s	INPUTLOOP		// repeat.
	// note: now, the numbers are in the range: [a7, a7+d3)

	// Bubble Sort:
	// note: i starts at N-1 and goes down to 1, j starts at 0 and goes to N-2.
	//       At each iteration, compare j and j+1 and swap if j>j+1.
	//       On the last iteration of the outer loop, 
	// note: d0 is i, d4 is j, d3 is N, d1 & d2 are temp (?)
	move.b	d3, d0			// start i as N
	move.l	#0, d4			// clear j
	lsl.l	#2, d0			// mult i by 4

	LOOPI:
		subi.l	#4, d0			// decrement i; now i is pointing to the last element that will be compared. (on first iteration, i=N-1)



		clr.l	d4				// set j to 0
		LOOPJ:
			// Compare [j] with [j+1].  If [j] > [j+1], swap [j] and [j+1].
			move.l	0(a7,d4), d1		// put [j] into d1
			move.l	4(a7,d4), d2		// put [j+1] into d2
			cmp.l	d1, d2				// compare [j] with [j+1]
			bge		NOSWAP				// if d2 ([j+1]) >= d1 ([j]), don't swap.
				// Swap [j] and [j+1].
				move.l	d1, 4(d4,a7) 		// put d1 ([j]) into [j+1]
				move.l	d2, (d4,a7)			// put d2 ([j+1]) into [j]
			NOSWAP:

			addi.l	#4, d4			// increment j
			cmp.l	d0, d4			// compare i and j, and
			bne.s	LOOPJ			// loop back to inner loop if j hasn't reached i

		cmpi.l	#4, d0			// compare i to 1
		bne.s	LOOPI			// go back to outer loop if i hasn't gotten down to 1

	// Display ascending then descending.
	jsr		printasc
	jsr		printdes

/* //OLD: LAB02.
	// Initialize the value of current value of the sequence (and the LEDs):
	move.b #$0, d1
	move.b d1, $4010000F

	move.l	#$1, d3 // initialize previous value of the sequence as 1





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
	*/


	//======= Let the following few lines always end your main routing ===//
	//------- No OS to return to so loop infinitely...Never hits rts --- //
	endloop:

		bra.s	endloop
		rts

//------ Defines subroutines here ------- //
//------  Replace sub1 definition ------- //
initio:
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
	rts



// Wait for the switches' value to change then store that to d1
getinput:
	move.l	d2, -(a7)		// store d2 onto stack so we don't overwrite

	clr.l	d1				// clear upper bits of d1
	clr.l	d2				// clear upper bits of d2
	move.b	$40100044, d2	// put current value of switches into d1
	BUSYWAIT:
		move.b	$40100044, d1	// put current value of switches into d1
		cmp.l	d1, d2			// compare new and old values of switches
		beq.s	BUSYWAIT		// and loop if it hasn't changed

	lsr.l	#4, d1			// shift d1 4 bits to the right so that the switches' value goes directly to a number

	move.l	(a7)+, d2		// put back the value of d2
	rts


// Print the memory's contents, from 0 to d4 (N)
printasc:
	move.l	d0, -(a7)		// store d0 onto stack so we don't overwrite
	move.l	d1, -(a7)		// store d1 onto stack so we don't overwrite
	move.l	d4,	-(a7)
	move.l	d2, -(a7)

	// note: now the stack is like this:
	// a7 -> d1
	//       d0
	//       (return address)
	//       (first element of array)
	//       (second element of array)
	//       ...
	//       (d3-1'th element of array)
	//       (other memory)

	clr.l	d0				// initialize d0 to 0
	clr.l	d4
	move.l	d3,d4
	lsl.l	#2, d4
	PRINTLOOPASC:
		move.l	#$7FFFFF, d2
		DELAYLOOPA:
			subq.l	#$1, d2			// note: keep this #0x1 so that d2 will definitely get to zero no matter what the initial value of d2 is set to
			bne.s	DELAYLOOPA

		move.l	20(a7,d0), d1	// put the current value into d1... note: the 8 is because a7 is pointing to the old values of d0 and d1
		jsr		ee357_put_int	// print the current value
		move.b	d1, $4010000F	// light up the LEDs with the current value	
		addi.l	#4, d0			// increment d0
		cmp.l	d0, d4			// compare d0 and N
		bgt.s	PRINTLOOPASC

	move.l	(a7)+, d2
	move.l	(a7)+, d4
	move.l	(a7)+, d1		// put back the value of d1
	move.l	(a7)+, d0		// put back the value of d0

	rts


// Print the memory's contents, from d4 (N), 0
printdes:
	move.l	d0, -(a7)		// store d0 onto stack so we don't overwrite
	move.l	d1, -(a7)		// store d1 onto stack so we don't overwrite
	move.l	d2, -(a7)

	clr.l	d0				// initialize d0 to N
	move.l	d3,d0
	lsl.l	#2, d0
	PRINTLOOPDES:
		move.l	#$7FFFFF, d2
		DELAYLOOPD:
			subq.l	#$1, d2			// note: keep this #0x1 so that d2 will definitely get to zero no matter what the initial value of d2 is set to
			bne.s	DELAYLOOPD

		move.l	12(a7,d0), d1	// put the current value into d1... note: the 8 is because a7 is pointing to the old values of d0 and d1
		jsr		ee357_put_int
		move.b	d1, $4010000F	// light up the LEDs with the current value	
		subi.l	#4, d0			// increment d0
		cmpi.l	#0, d0			// compare d0 and N
		bgt.s	PRINTLOOPDES

	move.l	(a7)+, d2
	move.l	(a7)+, d1		// put back the value of d1
	move.l	(a7)+, d0		// put back the value of d0


	rts
