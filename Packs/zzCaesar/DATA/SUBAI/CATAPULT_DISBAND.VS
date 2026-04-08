//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive) {
		Settlement set;
		ObjList units;
		Obj o;
		point pt_pos, pt_escape, pt_move;
		str cmd;

		set = .settlement;
		pt_pos = .pos;

		pt_escape = .CalcEscapeDirection();
		pt_escape.SetLen(.radius * 5);

		units = set.Units;

		while (units.count > 0) {
			o = units[0];
			if (o.IsAlive) {
				cmd = o.command;
				if (cmd != "attach")
					if (cmd != "move")
						if (cmd != "advance")
							if (cmd != "attack")
								if (cmd != "engage") {
									pt_move = pt_escape;
									pt_move.Rot(30 - rand(61));
									o.SetCommand("move", pt_move + pt_pos);
								}
			}

			Sleep(1000);//this must be greater than or equal to the exit_interval property of the catapult class

			units = set.Units;
		}
	}