//void, Obj This

Settlement this;
int player;

this = This.AsBuilding().settlement;

Sleep(rand(1501) + 500);

player = .player;

while (1) {
	if (IsResearched(this, "Grain Trade"))
		if (.food >= 10) {
			.SetFood(.food - 10);
			.SetGold(.gold + 5);
			.GoldConverted(5);
		}

	if (IsResearched(this, "Religious Feast")) {
		ObjList ol;
		Unit u;
		int i;

		ol = .ObjectsAround("Military");

		for (i = ol.count - 1; i >= 0; i -= 1) {
			u = ol[i].AsUnit();
			if (u.IsValid) {
				if (u.IsAlive) {
					if (u.health >= u.maxhealth)
						ol.Remove(u);
					else if (This.IsEnemy(u))
						ol.Remove(u);
				}
				else
					ol.Remove(u);
			}
			else
				ol.Remove(u);
		}

		for (i = 0; i < 5; i += 1)
			if (ol.count > 0) {
				u = ol[rand(ol.count)].AsUnit();
				if (u.IsValid)
					if (u.IsAlive)
						if (u.health < u.maxhealth)
							if (!This.IsEnemy(u)) {
								u.Heal(MIN(30, u.maxhealth - u.health));
								if (!u.InHolder)
									CreateFeedback("Heal", u);
							}
				ol.Remove(u);
			}
			else
				break;
	}

	if (player != .player) {
		Obj expedition_watch_eye;

		player = .player;

		expedition_watch_eye = EnvReadObj(this, "ExpeditionWatchEye");

		if (expedition_watch_eye.IsValid)
			if (expedition_watch_eye.IsEnemy(This)) {//do not swap the operators to manage one-sided diplomacy (player A that can attack peaceful B takes the eye, but not the contrary)
				Obj invalid;

				expedition_watch_eye.Erase();
				EnvWriteObj(this, "ExpeditionWatchEye", invalid);
			}
			else {
				expedition_watch_eye.SetPlayer(player);
				expedition_watch_eye.SetCommand("infinite_spy");
			}
	}

	Sleep(2000);
}