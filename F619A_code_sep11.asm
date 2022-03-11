	;save 2 data registers to RAM addresses next to the points
	;10bbb2 = D2
	;10bbb3 = D4
	;A3 and A5 available for general use
	lea $0010BBB2,A3;load byte holder address for D2 into A3
	move.b D2,(A3);save the byte in D2 at 10BBB2
	lea $0010BBB3,A3;load byte holder address for D4 into A3
	move.b D4,(A3);save the byte in D4 at 10BBB3

	;code goes here

	;code ends here
	;restore begins here
	;restore registers from RAM
	lea $0010BBB2,A3;load byte holder address for D2 into A3
	move.b (A3),D2;restore saved byte back to D2
	lea $0010BBB3,A3;load byte holder address for D4 into A3
	move.b (A3),D4;save the byte in D4 at 10BBB3

	;general restore
	lea $00108500,A3
	lea $00108000,A5

	;per-player restore
	cmpi.b #$05,D4;are we P2? D4's byte is 5 if so
	beq P2Restoration
	lea $0010A84A,A0
	lea $00100D00,A4
	bra Leave

P2Restoration:
	lea $0010A85B,A0
	lea $00100900,A4

Leave:
	move.l A4,D7;whatever address is in A4 needs to go into D7
	;restore ends here
	jmp $00028730;go back to where we need to return to (if they are allowed to pick)