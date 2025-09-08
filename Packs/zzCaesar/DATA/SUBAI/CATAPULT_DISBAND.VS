//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive) {
		Settlement set;
		ObjList units;
		point pos, pt_escape, pt_move;
		int i;

		set = .settlement;
		pos = .pos;

		pt_escape = .CalcEscapeDirection();
		pt_escape.SetLen(.radius * 5);

		units = set.Units;

		while (units.count > 0) {
			for (i = 0; i < units.count; i += 1) {
				pt_move = pt_escape;
				pt_move.Rot(30 - rand(61));
				if (units[i].command != "attach")
					units[i].SetCommand("move", pt_move + pos);
			}

			Sleep(1000);

			units = set.Units;
		}
	}