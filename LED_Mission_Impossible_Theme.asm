#include <p18F4520.inc>
		radix dec				
	
lp_cnt1	equ		0x21
lp_cnt2 equ		0x22
lp_cnt3	equ		0x23
lp_cnt4	equ		0x24
		
dup_nop macro kk    ; 625 dupnops for 50ms
		variable i
i = 0
		while i<kk
		nop
i=i+1
		endw
		endm
		
		org			0x00
		goto		start
		org			0x08
		retfie
		org			0x18
		retfie
						
start	movlw	D'15'
		movwf	0x29, A	
		movlw	B'00000000';set PORTD as output for LED
		movwf	TRISD	
		movlw	B'11111111' ; None light up
		movwf	PORTD
		call	delay_3s
		movlw	B'00000000'; Light up all LED
		movwf	PORTD
		call 	delay_3s ; delay3s so LED stay lit for 3s	
						 ; next alarm for 3sec
		movlw	D'7' ;
		movwf	0x30, A
		
loopAlarm3sec	
		movlw	B'10101010'
		movwf	PORTD	
		call	delay_01875s
		movlw	B'01010101'
		movwf	PORTD
		call	delay_01875s	
		decfsz	0x30,F,A
	 	bra		loopAlarm3sec
	 	movlw	D'4'
	 	movwf	0x31,A
	 				; next soft MI tune for 6s
loopSoftMI
		movlw	B'11100111'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11100111'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11000011';same thing different pattern
		movwf	PORTD
		call	delay_01875s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11000011'
		movwf	PORTD
		call	delay_01875s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_01875s
		decfsz	0x31,F,A
		bra		loopSoftMI
		movlw	D'6'
	 	movwf	0x32,A
	 				; next soft MI tune for 6s
loopHardMI
		movlw	B'11101111'
		movwf	PORTD
		call	delay_02s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		movlw	B'11101111'
		movwf	PORTD
		call	delay_02s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		movlw	B'00000000';same thing different pattern
		movwf	PORTD
		call	delay_02s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		movlw	B'00000000'
		movwf	PORTD
		call	delay_02s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		decfsz	0x32,F,A
		bra		loopHardMI	
		
		movlw	D'4'
		movwf	0x33,A
loopTransition	
		movlw	B'01111111'	
		movwf	PORTD
		call	delay_02s
		movlw	B'10111111'	
		movwf	PORTD
		call	delay_02s
		movlw	B'11011111'	
		movwf	PORTD
		call	delay_02s
		movlw	B'11101111'	
		movwf	PORTD
		call	delay_02s
		movlw	B'11110111'	
		movwf	PORTD
		call	delay_02s
		movlw	B'11111011'	
		movwf	PORTD
		call	delay_02s
		movlw	B'11111101'	
		movwf	PORTD
		call	delay_02s		
		movlw	B'11111110'	
		movwf	PORTD
		call	delay_02s
		decfsz	0x33,F,A
		bra		loopTransition	
		movlw	D'3'
		movwf	0x34
loopDoubt
		 movlw	B'01111111'
		 movwf	PORTD
		 call	delay_02s
		 movlw	B'10011111'
		 movwf	PORTD
		call	delay_02s
		call	delay_02s
		movlw	B'11100000'
		movwf	PORTD
		call	delay_1s
		call	delay_1s
		call	delay_02s
		decfsz	0x34,F,A
		bra		loopDoubt
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		movlw	B'00000000'
		movwf	PORTD
		call	delay_02s
		movlw	B'11111111'
		movwf	PORTD
		call	delay_02s
		movlw	B'00000000'
		movwf	PORTD
		call	delay_3s
forever	movlw	B'11111111'
		movwf	PORTD		
		bra forever
		



delay_3s
		movlw	175
		movwf	lp_cnt1,A
loop1	movlw	250
		movwf	lp_cnt2,A
loop2	dup_nop 17
		decfsz	lp_cnt2,F,A
		bra		loop2
		decfsz	lp_cnt1,F,A
		bra		loop1
		return
		
delay_1s
		movlw	50
		movwf	lp_cnt3,A
loop3	movlw	250
		movwf	lp_cnt4,A
loop4	dup_nop 17
		decfsz	lp_cnt4,F,A
		bra		loop4
		decfsz	lp_cnt3,F,A
		bra		loop3
		return		
		

	
delay_01875s movlw D'15'
		movwf PRODL 	
delay;12.5ms 0.0125s
		movlw 0x83
		movwf T0CON,A
loopd	movlw 0xFF
		movwf TMR0H
		movlw 0x3C
		movwf TMR0L,A		
		bcf INTCON,TMR0IF,A ; clear the TMR0IF flag
wait 	btfss INTCON,TMR0IF,A ;
 		bra wait ; wait until 50 ms is over
 		decfsz PRODL,F,A
 		bra loopd
 		return 
 		
delay_02s movlw D'3'
		movwf PRODL 	
delay_5ms;12.5ms 0.0125s
		movlw 0x83
		movwf T0CON,A
loopd1	movlw 0xFC
		movwf TMR0H
		movlw 0xF2
		movwf TMR0L,A		
		bcf INTCON,TMR0IF,A ; clear the TMR0IF flag
wait1 	btfss INTCON,TMR0IF,A ;
 		bra wait1 ; wait until 50 ms is over
 		decfsz PRODL,F,A
 		bra loopd1
 		return 		
		 		
		
		end



