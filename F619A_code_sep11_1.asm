	;save 2 data registers to RAM addresses next to the points
	;10bbb2 = D2
	;10bbb3 = D4 (used in P1/P2 check)
	;A3 and A5 available for general use
	lea $0010BBB2,A3;load byte holder address for D2 into A3
	move.b D2,(A3);save the byte in D2 at 10BBB2
	lea $0010BBB3,A3;load byte holder address for D4 into A3
	move.b D4,(A3);save the byte in D4 at 10BBB3

	;code goes here
	;using D2,D7,A0,A3,A4,A5
	;D4 also available for use AFTER we have done all necessary P1/P2 checks

	lea $0010FDAC,A0;load start button toggle addr into A0
	move.b (A0),D2;move start button byte into D2
	tst.b D2;is button toggle zero?
	beq TableLookup;if start is not held down by either player, go to table check
	;01,05=p1.04,05=p2. if it's 04, skip to PlayerTwoAltCheck
	cmpi.b #$04,D2;is it P2 only holding start?
	beq PlayerTwoAltCheck

PlayerOneAltCheck:
	;code goes here
	nop
	;after P1 is done with their stuff, let's see if we need to flow into P2 as well
	;(if it was 5)
P2hadStartAlso:
	cmpi.b #$05,D2;were both players holding start?
	bne BeginRestore

PlayerTwoAltCheck:
	;code goes here
	nop
	bra BeginRestore

TableLookup:
	;slot is in D0
	;chr ID is in D1
	;let's load player's points into D2
	cmpi.b #$05,D4;are we P2? D4 is 05 if so
	beq LoadP2PointsAddress
	lea $0010BBB0,A3
	bra MovePointsIntoRegister
LoadP2PointsAddress:
	lea $0010BBB1,A3
MovePointsIntoRegister:
	move.b (A3),D2;current player's points are now loaded into D2
;now we need to load this character's cost into D7
	lea $000FFFDA,A4;table data at EOF
	add D1,A4;add char ID number to table pointer
	move.b (A4),D7;move cost of character into D7
;WE NEED CHECKS TO DETERMINE IF THIS IS THE 2ND SELECTION! IF SO, THEY
;MUST HAVE 2 PTS LEFT OVER AFTER PICKING CHR 2
;remaining points minus 2 = max a player can spend on character B
;do a check to see if we're in the 2nd character choice
;if we are, subtract 2 from D2 (not the RAM address)
	cmp #01,D0
	bne ContinueToCompare
	subq.b #02,D2
ContinueToCompare:
	cmp.b D7,D2;D2=points,D7=cost
	bge SubtractIfAllowed;if they are allowed to pick
;code goes here if they are NOT allowed to pick - dump them off
	bra CantTake;dont subtract pts
SubtractIfAllowed:
;we still have this character's points address loaded into A3
	sub.b D7,D2;subtract cost from points
	move.b D2,(A3);put the new points total into the player's address


	;code ends here
	;restore registers from RAM begins here
BeginRestore:
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

P1Restoration:
	lea $0010A84A,A0
	lea $00100D00,A4
	move.l A4,D7;whatever address is in A4 needs to go into D7
	bra Leave

P2Restoration:
	lea $0010A85B,A0
	lea $00100900,A4
	move.l A4,D7;whatever address is in A4 needs to go into D7
	;restore ends here

Leave:
	jmp $00028730;go back to where we need to return to (if they are allowed to pick)

CantTake:
;need to restore registers?
	jmp $0000a142