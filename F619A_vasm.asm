	lea $0010FDAC,A3;load start button toggle addr into A3
	move.b (A3),D2;move start button byte into D2
	tst.b D2;is button toggle zero?
	beq TableLookup;if start is not held down by either player, go to table check

PlayerOneAltCheck:
	cmpi.b #$04,D4;are we player 1?
	bne PlayerTwoAltCheck;if we are not player 1, go to the p2 check

PlayerTwoAltCheck:
	nop

AltLookup:
	tst.b D4

TableLookup:
