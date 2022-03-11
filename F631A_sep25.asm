	;coming here from 286c4 (every frame)
	;lets save D0 to RAM and then replace it later
	lea $0010BBB8,A0
	move.b D0,(A0)

	;100d56 is p1's string (00 when 2p is present)  (others are 00 when only p1 is present)
	;100756 is p1's string when both present
	;100956 is p2's string when both present	
	;free to use D0,D2,A0,A2,A3,A5
	lea $49494920,A2

	lea $00100d56,A0
	tst.b (A0)
	beq BothPlayersOverwrite	
	move.l A2,(A0)

BothPlayersOverwrite:
	lea $00100756,A0
	move.l A2,(A0)
	add.w #$200,A0
	move.l A2,(A0)

EndingReplace:
	;restore what we replaced
	lea $0010BBB8,A0;D0 is stored here
	move.b (A0),D0
	lea $000B4452,A0
	lea $0000990E,A2
	lea $00108500,A3
	lea $00108000,A5
	clr.l D2 ;D2 should be 00000000

	;go back to where we came from
	jmp $000286CA