Settlement set;
point p;

ExploreAll();
SetFog(false);

set = GetSettlement("S_Town1");
p = set.GetCentralBuilding().pos;
p.Set(p.x, p.y - 150);

while (1) {
	if (set.player == 1) {
		int units_to_spawn, i;
		Unit u;
		units_to_spawn = 30 - Group("B_Archers").count;
		for (i = 0; i < units_to_spawn; i += 1) {
			u = Place("BBowman", p, 1).AsUnit();
			u.SetLevel(MAX(4, u.inherentlevel));
			u.SetFeeding(false);
			u.AddToGroup("B_Archers");
			set.ForceAddUnit(u);
		}
	}
	Sleep(60000);
}