//void, Obj THIS

Unit this;

this = THIS.AsUnit();

if (.IsValid) {
	int player;

	//this is to avoid damaging units with trample and constantly creating useless visual effects
	.SetSpecial(revenge, false);
	.SetSpecial(spike_armor, false);
	.SetSpecial(defense_skill, false);
	.SetSpecial(defensive_tactics, false);
	.SetSpecial(deflection, false);
	.SetSpecial(determination, false);

	.SetNoAIFlag(true);

	player = .player;

	if (IsResearched(player, "Mercenary pact")) {
		Hero h;
		h = .hero;
		if (h.IsValid)
			if (player == h.player) {
				Item item;
				int i, gold_base, gold;
				gold_base = GetConst("MercenaryPactGold");
				gold = gold_base;
				for (i = 1; i <= .items_count; i += 1) {
					item = .GetItem(i);
					if (item.name == "Spoils of War")
						gold += gold_base;
				}
				item = h.FindItem("Gold");
				//find item and add gold or spawn an item if there is space in inventory and add gold
				if (item.IsValid)
					item.SetUseCount(item.use_count + gold);
				else if (h.AddItem("Gold")) {
					item = h.FindItem("Gold");
					item.SetUseCount(gold);
				}
			}
	}
	if (IsResearched(player, "Mercenary heal")) {
		ObjList ol;
		Unit u;
		int i, heal;
		heal = .maxhealth / 50;
		ol = ObjsInCircle(.pos, 350, "Unit").GetObjList();
		ol.ClearDead();
		for (i = 0; i < ol.count; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				if (player == u.player)
					if (u.health < u.maxhealth) {
						u.Heal(heal);
						CreateFeedback("Heal", u);
					}
		}
	}
}