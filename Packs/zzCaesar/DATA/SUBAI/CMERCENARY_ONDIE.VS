//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid) {
	int plr;

	plr = .player;

	if (!.InHolder) {
		//this is to avoid damaging units with trample and constantly creating useless visual effects
		.SetSpecial(revenge, false);
		.SetSpecial(spike_armor, false);
		.SetSpecial(defense_skill, false);
		.SetSpecial(defensive_tactics, false);
		.SetSpecial(deflection, false);
		.SetSpecial(determination, false);

		.SetNoAIFlag(true);

		if (IsResearched(plr, "Mercenary heal")) {
			ObjList ol;
			Obj o;
			int i, heal;

			heal = .maxhealth / 50;
			ol = ObjsInCircle(.pos, 350, "Unit").GetObjList();

			for (i = ol.count - 1; i >= 0; i -= 1) {
				o = ol[i];
				if (o.IsAlive)
					if (o.player == plr)
						if (o.health < o.maxhealth) {
							o.Heal(heal);
							CreateFeedback("Heal", o.AsUnit());
						}
			}
		}
	}

	if (IsResearched(plr, "Mercenary pact")) {
		Hero h;

		h = .hero;

		if (h.IsAlive)
			if (h.player == plr) {
				Item item;
				int i, gold = 40;

				for (i = .items_count; i >= 1; i -= 1) {
					item = .GetItem(i);
					if (item.IsValid)
						if (item.name == "Spoils of War")
							gold += 40;
				}

				item = h.FindItem("Gold");
				if (item.IsValid)
					item.SetUseCount(item.use_count + gold);
				else if (h.AddItem("Gold")) {
					item = h.FindItem("Gold");
					item.SetUseCount(gold);
				}
			}
	}
}