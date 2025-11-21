//void, str GroupName, str TargetArea

ObjList ol_guards;
Obj target;
Unit u;
point area_centre;
int i;

area_centre = AreaCenter(TargetArea);

AttackArea(Group(GroupName), TargetArea);

Sleep(1500);

while (1) {
	ol_guards = Group(GroupName).GetObjList();
	if (ol_guards.count <= 0)
		return;
	for (i = 0; i < ol_guards.count; i += 1) {
		u = ol_guards[i].AsUnit();
		if (u.IsValid)
			if (u.IsAlive)
				if (!u.AsUnit().hero.IsValid)
					if (AreaDistTo(u.pos, TargetArea) >= 525)//return to the area when too far
						u.SetCommand("move", area_centre);
					else if (u.command == "engage") {//this check must stay before the validity one to avoid resetting the advance_aggressive command
						if (!target.IsValid)
							target = u.BestTargetInSquadSight();//the first/new enemy sighted is marked as the main target
					}
					else if (target.IsValid) {
						if (target.IsDead)//the next enemy sighted will be marked as the main target
							target.Clear();
						else if (AreaDistTo(target.posRH, TargetArea) <= 525) {
							if (u.command == "move") {
								if (u.DistTo(area_centre) <= 350)//units that are coming back after being too far should keep moving until they are near the area centre
									u.SetCommand("advance_aggressive", target.posRH);
							}
							else if (u.command != "advance_aggressive")
								u.SetCommand("advance_aggressive", target.posRH);
						}
						else
							target.Clear();
					}
					else if (u.command == "move") {
						if (u.DistTo(area_centre) <= 350)//it's not necessary to move all the way back to the area centre
							u.SetCommand("advance_aggressive", GetRandomPointInArea(TargetArea));
					}
					else if (u.command != "advance_aggressive")
						u.SetCommand("advance_aggressive", GetRandomPointInArea(TargetArea));
	}
	Sleep(1500);
}