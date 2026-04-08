//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

StrArray classes;
IntArray players;
Obj o;
str o_class;
int i, j, k, p;
bool add_class_player;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive) {
		o_class = o.class;
		if (o_class == "RLiberatusPunic")
			o_class = "RLiberatus";

		p = o.player;

		add_class_player = true;

		for (j = 0; j <= k; j += 1)
			if (classes[j] == o_class)
				if (players[j] == p) {
					add_class_player = false;
					break;
				}

		if (add_class_player) {
			classes[k] = o_class;
			players[k] = p;
			k += 1;
		}
	}
}

if (k > 0) {
	ObjList selected_units;

	for (i = 0; i <= k; i += 1)
		selected_units.AddList(GetPlayerUnits(players[i], classes[i]));//attached units are excluded to avoid problems (see GetPlayerUnits comments in other scripts)

	selected_units.RemoveList(_GetSelection());//this reduces the lag caused by holding down the hotkey

	for (i = selected_units.count - 1; i >= 0; i -= 1) {
		o = selected_units[i];
		if (o.IsAlive)
			if (!o.AsUnit().hero.IsValid)
				if (players.find(o.player) > 0)
					o.Select(player);
	}
}