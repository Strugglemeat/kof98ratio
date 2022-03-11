*need to analyze registers to see which we can use*
bp f619a
====================
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
;using A0,A1,A2,A3












;restore registers that were used (consult **RATIO CHECK NEW CODE)

move.l 00000008,D0;203C 0000 0008
move.l 0000FFFF,D1;223C 0000 FFFF
move.l 00000010,D2;243C 0000 0010
move.l 00010004,D4;283C 0001 0004

lea 000284A0,a0;41f9 0002 84A0;restore what was in a0
lea 0010DA61,a1;43f9 0010 DA61;restore what was in a1
lea 0000990E,a2;45f9 0000 990E;restore what was in a2
lea 00108500,a3;47f9 0010 8500;restore what was in a3

jmp 000286e0;4E F9 00 02 86 E0