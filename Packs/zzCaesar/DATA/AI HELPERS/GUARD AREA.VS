//void, str group_name, str area_name

ObjList ol_guards;
Obj target;
Unit u;
point area_centre;
int i;

area_centre = AreaCenter(area_name);

AttackArea(Group(group_name), area_name);

Sleep(2000);

while (true) {
	ol_guards = Group(group_name).GetObjList();
	if (ol_guards.count <= 0)
		return;
	for (i = ol_guards.count - 1; i >= 0; i -= 1) {
		u = ol_guards[i].AsUnit();
		if (u.IsValid)
			if (u.IsAlive)
				if (u.hero.IsDead)
					if (AreaDistTo(u.pos, area_name) >= 525)//return to the area when too far
						u.SetCommand("move", area_centre);
					else if (u.command == "engage") {//this check must stay before the validity one to avoid resetting the advance_aggressive command
						if (target.IsDead)
							target = u.BestTargetInSquadSight();//the first/new enemy sighted is marked as the main target
					}
					else if (target.IsAlive) {
						if (AreaDistTo(target.posRH, area_name) >= 525)
							target.Clear();
						else if (u.command == "move") {
							if (u.DistTo(area_centre) <= 300)//units that are coming back after being too far should keep moving until they are near the area centre
								u.SetCommand("advance_aggressive", target.posRH);
						}
						else if (u.command != "advance_aggressive")
							u.SetCommand("advance_aggressive", target.posRH);
					}
					else if (u.command == "move") {
						if (u.DistTo(area_centre) <= 300)//it's not necessary to move all the way back to the area centre
							u.SetCommand("advance_aggressive", GetRandomPointInArea(area_name));
					}
					else if (u.command != "advance_aggressive")
						u.SetCommand("advance_aggressive", GetRandomPointInArea(area_name));
	}
	Sleep(2000);
}