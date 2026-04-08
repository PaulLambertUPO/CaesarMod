//void, Obj This

Sleep(1000 + rand(1001));

if (This.AsBuilding().IsValid) {
	Settlement this;
	ObjList ol;
	Obj o;
	int i, plr;

	this = This.AsBuilding().settlement;

	plr = .player;

	while (true) {
		if (IsResearched(this, "Grain Trade"))
			if (.food >= 10) {
				.SetFood(.food - 10);
				.SetGold(.gold + 5);
				.GoldConverted(5);
			}

		if (EnvReadInt(this, "IsStoring") == 1)
			if (.food > 0) {
				EnvWriteInt(this, "FoodStorage", EnvReadInt(this, "FoodStorage") + CLAMP(.food, 0, 10));
				.SetFood(MAX(0, .food - 10));
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
				if (o.IsEnemy(This))//non-hostile players give the eye
					o.Erase();
				else {
					o.SetPlayer(plr);
					o.SetCommand("infinite_spy");
				}
		}

		Sleep(2000);
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);