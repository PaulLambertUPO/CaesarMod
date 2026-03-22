//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

ObjList units;
Obj o;
int i, c;

units = objs[0].AsBuilding().settlement.Units;

for (i = units.count - 1; i >= 0; i -= 1) {
	o = units[i];
	if (o.IsDead)
		units.Remove(o);
	else if (o.AsUnit().hero.IsValid)
		units.Remove(o);
	else if (o.command == "follow")
		units.Remove(o);
	else if (!DiplGetShareControl(o.player, player))
		units.Remove(o);
}

c = units.count;

if (c > 0) {
	ClearSelection(player);

	for (i = 0; i < c; i += 1)
		units[i].Select(player);

	units.SetCommand("advance", pt);
}