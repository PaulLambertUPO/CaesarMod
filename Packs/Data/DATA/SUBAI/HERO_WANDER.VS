//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		point where;
		int i;

		while (.CmdCount <= 1) {//avoid blocking pending commands forever
			where.SetLen(50 + rand(.sight));
			where.Rot(rand(360));

			.FormSetupAndMoveTo(pt + where, 0, 0, true);

			for (i = 0; i < 10; i += 1) {
				if (!.HasPath)
					break;
				.FormKeepMoving(1000);
			}

			Sleep(2000 + rand(3001));
		}
	}

Sleep(30);//prevent possible loops with other commands