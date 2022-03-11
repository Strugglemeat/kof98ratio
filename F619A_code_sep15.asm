	;save 2 data registers to RAM addresses next to the points
	;10bbb2 = D2
	;10bbb3 = D4 (used in P1/P2 check)
	;A3 and A5 available for general use
	lea $0010BBB2,A3;load byte holder address for D2 into A3
	move.b D2,(A3);save the byte in D2 at 10BBB2
	;lea $0010BBB3,A3;load byte holder address for D4 into A3
	addq #$01,A3;rather than inputting the entire address
	move.b D4,(A3);save the byte in D4 at 10BBB3
	addq #$01,A3;location where we will save the word from A4
	move.w A4,(A3);save the word from A4 to be restored later

	;code goes here
	;using D2,D7,A0,A3,A4,A5
	;D4 also available for use AFTER we have done all necessary P1/P2 checks

	move.b $FF,D7;move FF into D7 to later see if we've put something in it after alt chr

	lea $0010FDAC,A0;load start button toggle addr into A0
	move.b (A0),D2;move start button byte into D2
	tst.b D2;is button toggle zero?
	beq TableLookup;if start is not held down by either player, go to table check

	;code after this line is if start is held down. now let's determine the cost
	;of which char they want and put it into D7
	;if they can afford, send them to ChoosingSecondCharacterCheck
	;if they can't afford, send them out

Kyo:
	cmpi.b #$00,D1
	bne Yashiro
	moveq #$7,D7
	bra InitialStartCheck
Yashiro:
	cmpi.b #$15,D1
	bne Shermie
	moveq #$9,D7
	bra InitialStartCheck
Shermie:
	cmpi.b #$16,D1
	bne Chris
	moveq #$4,D7
	bra InitialStartCheck
Chris:
	cmpi.b #$17,D1
	bne Terry
	moveq #$0B,D7
	bra InitialStartCheck
Terry:
	cmpi.b #$03,D1
	bne Andy
	moveq #$5,D7
	bra InitialStartCheck
Andy:
	cmpi.b #$04,D1
	bne Joe
	moveq #$3,D7
	bra InitialStartCheck
Joe:
	cmpi.b #$05,D1
	bne Ryo
	moveq #$4,D7
	bra InitialStartCheck
Ryo:
	cmpi.b #$06,D1
	bne Robert
	moveq #$8,D7
	bra InitialStartCheck
Robert:
	cmpi.b #$07,D1
	bne Yuri
	moveq #$6,D7
	bra InitialStartCheck
Yuri:
	cmpi.b #$08,D1
	bne BillyKane
	moveq #$4,D7
	bra InitialStartCheck
BillyKane:
	cmpi.b #$1A,D1
	bne Mai
	moveq #$3,D7
	bra InitialStartCheck
Mai:
	moveq #$10,D7

InitialStartCheck:
	;01,05=p1.04,05=p2. if it's 04, skip to PlayerTwoAltCheck
	cmpi.b #$04,D2;is it P2 only holding start?
	beq PlayerTwoStartCheck

PlayerOneStartCheck:
	cmpi.b #$05,D4;are we P2? D4 is 05 if so
	beq P2hadStartAlso;if we are P2, we don't want to load p1 points address
	bra LoadP1PointsAddress

P2hadStartAlso:;we only come here if we are P2
	cmpi.b #$05,D2;were both players holding start?
	bne BeginRestore;if it was neither $04 (check above) or $05 (check here), then it wasn't P2

PlayerTwoStartCheck:
	cmpi.b #$05,D4;are we P2? D4 is 05 if so
	bne LoadP1PointsAddress
	bra LoadP2PointsAddress;it was $05 (both had start)

TableLookup:
	;slot is in D0
	;chr ID is in D1
	;let's load player's points into D2
	cmpi.b #$05,D4;are we P2? D4 is 05 if so
	beq LoadP2PointsAddress
LoadP1PointsAddress:
	lea $0010BBB0,A3
	bra MovePointsIntoRegister
LoadP2PointsAddress:
	lea $0010BBB1,A3
MovePointsIntoRegister:
	move.b (A3),D2;current player's points are now loaded into D2
DoWeNeedTableLookup:;don't do LoadDesiredCharCost if we are taking an alt char
	cmpi.b #$FF,D7
	bne ChoosingSecondCharacterCheck
LoadDesiredCharCost:;now we need to load this character's cost into D7
	;lea $000FFFDA,A4;table data at EOF
	lea (TableData),A4;load table data address into A4
	add D1,A4;add char ID number to table pointer
	move.b (A4),D7;move cost of character into D7
;WE NEED CHECKS TO DETERMINE IF THIS IS THE 2ND SELECTION! IF SO, THEY
;MUST HAVE 2 PTS LEFT OVER AFTER PICKING CHR 2
;remaining points minus 2 = max a player can spend on character B
;do a check to see if we're in the 2nd character choice
;if we are, subtract 2 from D2 (not the RAM address)
ChoosingSecondCharacterCheck:
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
	;P1's A4 is dynamic based on whether P2 is present or not
	;if no P2 present, should be 100D00
	;if P2 present, should be 100700
	lea $00100D00,A4
	;after this, let's copy in the word from memory
	lea $0010BBB4,A0
	move.w (A0),A4
	move.l A4,D7;whatever address is in A4 needs to go into D7
	lea $0010A84A,A0
	bra Leave

P2Restoration:
	lea $0010A85B,A0
	lea $00100900,A4
	move.l A4,D7;whatever address is in A4 needs to go into D7
	;restore ends here

Leave:
	jmp $00028730;go back to where we need to return to (if they are allowed to pick)

CantTake:
;restore registers
;data
	move.l $100003F0,D0
	move.l $749D03F0,D2
	move.l $00010000,D4
	move.l $0000FFFF,D7
;address
	lea $0022F2F0,A0
	lea $00D00034,A1
	lea $003C0002,A3
	lea $00100700,A4
;leave
	jmp $0000a142

TableData:
	dc.l $09090B07
	dc.l $0407080A
	dc.l $05070706
	dc.l $0606040C
	dc.l $0A050509
	dc.l $0609050A
	dc.l $0807040B
	dc.l $09070408
	dc.l $07060502
	dc.w $0505