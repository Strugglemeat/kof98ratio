	lea 10bbb0,a4;49F9 0010 BBB0;p1 points address
	move.b #20,(A4);18BC 0020;should this be 0x14?
	moveq #1, D1;7201;d1 is free to use
	adda.w D1, A4;D8C1;increment A4 by 1 to get to P2 address
	move.b #20,(A4);18BC 0020;should this be 0x14?
	lea 108500,a4;49f9 0010 8500;restore what was in a4
	bra Finish;60 02;go to 277be
        jmp $f619a.l;4E F9 00 0F 61 9A;jump to injection