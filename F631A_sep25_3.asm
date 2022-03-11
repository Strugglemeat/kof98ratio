	;coming here from 2869e (every frame)
	;lets save D0 to RAM and then replace it later
	lea $0010BBB8,A0
	move.b D0,(A0)

	;100d56 is p1's string (00 when 2p is present)  (others are 00 when only p1 is present)
	;100756 is p1's string when both present
	;100956 is p2's string when both present	
	;free to use D0,D2,A0,A2,A3,A5
	lea $50545320,A5;this is the string that will be written between cost and player's points
	
	lea $00100d56,A0
	tst.b (A0);is 100d56 blank? if so, let's go to overwrite for both players
	beq BothPlayersOverwrite
	lea $0010BBB0,A2;P1's points address
BeginOverwrite:
	move.l A5,(A0);move the "PTS " string in
	addq #$04,A0;move forward in the string to where we will write next
	;WE NEED TO CONVERT FROM HEX TO DEC HERE
	lea $0010BBB9,A3;we will use this as the first byte of the cost print	
	cmpi.b #$14,(A2)
	bne P1SoloFirstDigit

WriteP1Twenty:
	move.b #$32,(A0)
	addq #$01,A0
	move.b #$30,(A0)
	bra AltCharOverwrite

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
	bra AltCharOverwrite

BothPlayersOverwrite:
	cmpi.b #$05,D4
	beq BothPlayersOverwriteP2
	lea $00100756,A0
	lea $0010BBB0,A2;P1's points address
	bra BeginOverwrite

BothPlayersOverwriteP2:
	lea $00100956,A0
	lea $0010BBB1,A2;P2's points address
	bra BeginOverwrite

AltCharOverwrite:
	lea $0010BBB8,A0;restore D0
	move.b (A0),D0;restore D0
	lea $0010fdac,A0;is the start button toggle on? (01=p1 only (could be one of two diff addresses), 04=p2 only (one address), 05=both p1 & p2(two known addresses))
	tst.b (A0)
	beq EndingReplace;if nobody is holding start, get out of here
	;there's an address register we can analyze to see what should be done here
	;A4.w = 0D00  p1 only, A4.w = 0700 p1 in both, A4.w = 0900 p2 in both
	move.l A4,D2
	cmpi.w #$0D00,D2
	bne CheckP2Only
	lea $00100d53,A5;first byte of new cost if P1 only
	bra Kyo
CheckP2Only:
	cmpi.w #$0700,D2
	bne CheckBothStart
	cmpi.b #04,(A0)
	beq CheckBothStart
	lea $00100753,A5;first byte of new cost if P1 when both are present
	bra Kyo
CheckBothStart:
	cmpi.w #$0900,D2
	bne Kyo
	cmpi.b #01,(A0)
	beq Kyo
	lea $00100953,A5;first byte of P2 COST text

Kyo:
	cmpi.b #$00,D0
	bne Shermie
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$37,D2
	move.b D2,(A5)
	bra EndingReplace
Shermie:
	cmpi.b #$16,D0
	bne Chris
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$34,D2
	move.b D2,(A5)
	bra EndingReplace
Chris:
	cmpi.b #$17,D0
	bne Terry
	moveq #$31,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$31,D2
	move.b D2,(A5)
	bra EndingReplace
Terry:
	cmpi.b #$03,D0
	bne Andy
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$35,D2
	move.b D2,(A5)
	bra EndingReplace
Andy:
	cmpi.b #$04,D0
	bne Joe
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$33,D2
	move.b D2,(A5)
	bra EndingReplace
Joe:
	cmpi.b #$05,D0
	bne Robert
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$34,D2
	move.b D2,(A5)
	bra EndingReplace
Robert:
	cmpi.b #$07,D0
	bne Yuri
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$36,D2
	move.b D2,(A5)
	bra EndingReplace
Yuri:
	cmpi.b #$08,D0
	bne Mai
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$34,D2
	move.b D2,(A5)
	bra EndingReplace
Mai:
	cmpi.b #$10,D0
	bne BillyKane
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$38,D2
	move.b D2,(A5)
	bra EndingReplace
BillyKane:
	cmpi.b #$1A,D0
	bne EndingReplace
	moveq #$30,D2
	move.b D2,(A5)
	addq #$01,A5
	moveq #$33,D2
	move.b D2,(A5)


EndingReplace:
	;restore what we replaced
	;lea $0010BBB8,A0;D0 is stored here
	;move.b (A0),D0
	add D0,D0;original code
	lea $000B44C0,A0;original code
	lea $0000990E,A2
	lea $00108500,A3
	lea $00108000,A5
	clr.l D2 ;D2 should be 00000000

	;go back to where we came from
	jmp $000286A4