//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		point pt_move;
		rect rc;
		int rad;

		if (!.GetFlags(UNITFLAG_NOAI))//this check avoids a crash if the script is restarted because SetNoAIFlag cannot be used after SetNoselectFlag
			.SetNoAIFlag(true);
		.SetNoselectFlag(true);
		.SetMinimapFlag(true);

		rc = GetMapRect();
		rad = .radius + 5;

		while (1) {
			pt_move.SetLen(300 + rand(351));
			pt_move.Rot(rand(360));
			pt_move = pt_move + .pos;
			if (pt_move.InRect(rc))
				if (IsPointInWater(pt_move))
					while (!.Goto(pt_move, rad, 10000, false, -1))
						if (.TimeWithoutWalking > 0)
							break;
			.Idle(500);
		}
	}