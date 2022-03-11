bp f619a
====================
-1) determine which player we are, 1 or 2 (where do we use this?)
0) load the start button toggle 10fdac
1) is the start button toggle on? (01=p1 only, 04=p2 only, 05=both p1 & p2)
1a) no -> lookup the cost and load it to the player's cost register
1b) yes -> go through all 12 and see if id matches, when the match is found, load it to the player's cost register
2) load the player's respective points to another register
3) compare the cost of the player's designed chr against the player's points
4) if they can afford it, proceed as usual
4a) if they cannot afford it, need to find a good place to dump them off
====================
;need at least 2 address registers and 2 data registers
;using D0,D1,D2,D4
;using A0,A1,A2,A3 (A5 but I can't restore it with lea so didn't add it)

lea 0010 FDAC,A3;47F9 0010 FDAC;load start button toggle addr into A3
move.b @A3,D4;1813;move start button byte into D4
tst.b D4;4A04;is it zero? (note that this isn't effective because it could be p1 choosing while p2 had start held. we need to compare against who this is, p1 can use 01 or 05, p2 can use 02 or 05)
bne 12AltLookup


	;10a84d is which chr p1 is selecting (00,01,02, finished=03)
	;10a85e is which chr p2 is selecting (00,01,02, finished=03)
	;3 chrs for p1 10A84e,10A84f,10A850
	;3 chrs for p2 10a85f,10a860,10a861

PC for writing chr taken = PC 28738 (chr ID was in D1)









;restore registers that were used (consult **RATIO CHECK NEW CODE)
restorations that are the same for both players:
move.l 00000010,D2;243C 0000 0010
lea 000284A0,a0;41f9 0002 84A0;restore what was in a0
lea 0000990E,a2;45f9 0000 990E;restore what was in a2
lea 00108500,a3;47f9 0010 8500;restore what was in a3

cmpi #$5, D4;0C04 0005  ;are we p2? D4's byte is 5 if so
beq 1A;67 1A ;skipping the p1 if we're p2

restorations for p1 only:
move.l 00000008,D0;203C 0000 0008
move.l 0000FFFF,D1;223C 0000 FFFF
move.l 00010004,D4;283C 0001 0004
lea 0010DA61,a1;43f9 0010 DA61;restore what was in a1 for p1
bra 18;60 18 ;bra to the jmp

restorations for p2 only:
move.l 000003FE,D0;203C 0000 03FE
move.l 00000700,D1;223C 0000 0700
move.l 00010005,D4;283C 0001 0005
lea 0010075D,a1;43f9 0010 075D;restore what was in a1 for p2

jmp 000286e0;4E F9 00 02 86 E0