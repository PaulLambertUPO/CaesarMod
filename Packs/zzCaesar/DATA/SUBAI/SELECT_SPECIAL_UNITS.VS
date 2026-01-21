//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

StrArray classes;
IntArray players;
Unit u;
str class;
int i, j, k, p;
bool add_class_player;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (u.IsAlive) {
			class = u.class;
			if (class == "RLiberatusPunic")
				class = "RLiberatus";

			p = u.player;

			add_class_player = true;

			for (j = 0; j <= k; j += 1)
				if (classes[j] == class)
					if (players[j] == p) {
						add_class_player = false;
						break;
					}

			if (add_class_player) {
				classes[k] = class;
				players[k] = p;
				k += 1;
			}
		}
}

if (k > 0) {
	ObjList selected_units;

	for (i = 0; i <= k; i += 1)
		selected_units.AddList(GetPlayerUnits(players[i], classes[i]));//hero-attached units are excluded to avoid problems (see GetPlayerUnits comments in other scripts)

	selected_units.RemoveList(_GetSelection());//this removes a lot of lag caused by the Select function when there are many units and the command keyboard shortcut is held down

	for (i = 0; i < selected_units.count; i += 1) {
		u = selected_units[i].AsUnit();
		if (u.IsValid)
			if (u.IsAlive)
				if (!u.hero.IsValid)
					if (players.find(u.player) > 0)
						u.Select(player);
	}
}