	;coming here from 2869e (every frame)
	;lets save D0 to RAM and then replace it later
	lea $0010BBB8,A0
	move.b D0,(A0)

	;100d56 is p1's string (00 when 2p is present)  (others are 00 when only p1 is present)
	;100756 is p1's string when both present
	;100956 is p2's string when both present	
	;free to use D0,D2,A0,A2,A3,A5
	;lea $49494920,A2
	lea $50545320,A2;this is the string that will be written between cost and player's points
	
	lea $00100d56,A0
	tst.b (A0);is 100d56 blank? if so, let's go to overwrite for both players
	beq BothPlayersOverwrite
	move.l A2,(A0);if it's only p1 present, then let's write
	addq #$04,A0;move forward in the string to where we will write next
	lea $0010BBB0,A2;P1's points address
	;WE NEED TO CONVERT FROM HEX TO DEC HERE
	lea $0010BBB9,A3;we will use this as the first byte of the cost print	
	cmpi.b #$14,(A2)
	bne P1SoloFirstDigit

WriteP1Twenty:
	move.b #$32,(A0)
	addq #$01,A0
	move.b #$30,(A0)
	bra EndingReplace

P1SoloFirstDigit:
	cmpi.b #$0A,(A2)
	blt P1SoloFirstDigitZero
	move.b #$31,(A0)
	bra P1SoloSecondDigit

P1SoloFirstDigitZero:
	move.b #$30,(A0)

P1SoloSecondDigit:
	addq #$01,A0;add 1 to A0 to get to the second byte we need to write
	move.b (A2),D0
	cmpi.b #$0A,D0;are the points 10 or greater?
	blt P1SoloSecondDigitWrite
	sub.b #$0A,D0

P1SoloSecondDigitWrite:
	;we need to add 30 to the number to get it to display as a string character
	add.b #$30,D0
	move.b D0,(A0)
	bra EndingReplace

BothPlayersOverwrite:
	lea $00100756,A0
	move.l A2,(A0)
	add.w #$200,A0
	move.l A2,(A0)

EndingReplace:
	;restore what we replaced
	lea $0010BBB8,A0;D0 is stored here
	move.b (A0),D0
	add D0,D0;original code
	lea $000B44C0,A0;original code
	lea $0000990E,A2
	lea $00108500,A3
	lea $00108000,A5
	clr.l D2 ;D2 should be 00000000

	;go back to where we came from
	jmp $000286A4