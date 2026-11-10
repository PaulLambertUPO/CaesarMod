//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Obj this;

this = objs[0];

if (.command == "idle") {
	int cost;

	cost = cmdcost_stamina;

	if (.stamina >= cost) {
		Unit u;
		point pt_pos;
		str u_class;
		int i, j;

		EnvWriteInt(.AsBuilding(), "CasterPlayer", player);//the caster is who executes the command, not the player of the controlling sages
		.SetStamina(.stamina - cost);
		.SetCommand(cmdparam);

		pt_pos = .pos;

		if (.IsHeirOf("Shrine")) {
			u_class = "LionMStonehenge";
			i = 1 + cost / 4;
		}
		else {
			u_class = "WolfStonehenge";
			i = 1 + cost / 3;
		}

		while (i > 0) {
			for (j = 0; j < 10; j += 1) {
				pt = pt_pos + RandomOffset(375);
				if (IsPassable3x3(pt)) {
					u = Place(u_class, pt, 15).AsUnit();
					u.SetLevel(MAX(2, cost / 10));
					u.SetCommand("advance", pt_pos);
					break;
				}
			}
			i -= 1;
		}
	}
}