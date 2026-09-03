//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		int plr;
		bool this_ai;

		plr = .player;
		this_ai = .AI;

		if (this_ai)
			if (IsProtected(plr, pt, "CoverOfMercy"))
				return;

		while (!.Goto(pt, .sight, 2000, false, 2500))
			;

		if (this_ai)
			if (IsProtected(plr, pt, "CoverOfMercy"))
				return;

		.PlayAnim(18, .pos);

		if (this_ai)
			if (IsProtected(plr, pt, "CoverOfMercy"))
				return;

		Place("CoverOfMercy", pt, plr).SetStamina(10);

		.PlaySound("Data/Sound Entities/CoverOfMercy.xml");

		.Damage(.health);
	}