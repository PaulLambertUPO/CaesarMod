//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		if (.AI) {
			Sleep(200 + rand(301));
			if (IsProtected(.player, .pos, "CoverOfMercy"))
				return;
			if (IsProtected(.player, pt, "CoverOfMercy"))
				return;
		}

		while (!.Goto(pt, .sight, 2000, false, 2500))
			;

		.PlayAnim(18, .pos);

		Place("CoverOfMercy", pt, .player).SetStamina(10);

		.Damage(.health);
	}