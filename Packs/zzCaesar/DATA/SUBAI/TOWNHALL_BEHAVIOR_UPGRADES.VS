//void, Obj This

Settlement this;
ObjList ol;
Obj o;
int i, plr;

this = This.AsBuilding().settlement;

Sleep(rand(1501) + 500);

plr = .player;

while (1) {
	if (IsResearched(this, "Grain Trade"))
		if (.food >= 10) {
			.SetFood(.food - 10);
			.SetGold(.gold + 5);
			.GoldConverted(5);
		}

	if (IsResearched(this, "Religious Feast")) {
		i = 0;
		ol = .ObjectsAround("Military");
		while (ol.count > 0) {
			o = ol[rand(ol.count)];
			if (o.IsAlive)
				if (o.health < o.maxhealth)
					if (!This.IsEnemy(o)) {
						o.Heal(30);
						CreateFeedback("Heal", o.AsUnit());
						i += 1;
						if (i >= 5)
							break;
					}
			ol.Remove(o);
		}
	}

	if (plr != .player) {
		plr = .player;
		o = EnvReadObj(this, "ExpeditionWatchEye");
		if (o.IsValid)
			if (o.IsEnemy(This))//do not swap the operators to manage one-sided diplomacy (player A that can attack peaceful B takes the eye, but not the contrary)
				o.Erase();
			else {
				o.SetPlayer(plr);
				o.SetCommand("infinite_spy");
			}
	}

	Sleep(2000);
}