//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

ObjList units;
Unit u;
int i;

units = objs[0].AsBuilding().settlement.Units;

for (i = units.count - 1; i >= 0; i -= 1) {
	u = units[i].AsUnit();
	if (!u.IsValid)
		units.Remove(u);
	else if (u.IsDead)
		units.Remove(u);
	else if (!DiplGetShareControl(player, u.player))
		units.Remove(u);
	else if (u.hero.IsValid)
		units.Remove(u);
}

if (units.count > 0) {
	ClearSelection(player);

	for (i = 0; i < units.count; i += 1)
		units[i].Select(player);

	units.ExecDefaultCmd(pt, obj, bReplace, bModifier);
}