//void, str GroupName, str TargetArea

Query q_guards;
ObjList ol_guards;
Unit u, enemy, target;
int i;

AttackArea(Group(GroupName), TargetArea);

Sleep(1500);

while (1) {
	ol_guards = Group(GroupName).GetObjList();
	if (ol_guards.count <= 0)
		return;
	for (i = 0; i < ol_guards.count(); i += 1) {
		u = ol_guards[i].AsUnit();
		if (u.IsValid)
			if (u.IsAlive)
				if (!u.AsUnit.hero.IsValid) {
					if (AreaDistTo(u.pos, TargetArea) >= 550)//return to the area when too far
						u.SetCommand("move", AreaCenter(TargetArea));
					else if (u.command == "engage") {
						if (!target.IsValid)//the first/new enemy sighted is marked as the main target
							target = u.BestTargetInSquadSight();
					}
					else if (target.IsValid) {
						if (target.IsDead)//the next enemy sighted will be marked as the main target
							target.Clear();
						else if (AreaDistTo(target.posRH, TargetArea) < 550)
							u.SetCommand("advance", target.posRH);
						else
							target.Clear();
					}
					else if (u.command == "idle")
						u.SetCommand("advance", GetRandomPointInArea(TargetArea));
					else if (u.command == "stand_position")
						u.SetCommand("advance", GetRandomPointInArea(TargetArea));
					else if (u.command == "move")
						if (u.DistTo(AreaCenter(TargetArea)) <= 320)//it's not necessary to move all the way back to the area centre
							u.SetCommand("advance", GetRandomPointInArea(TargetArea));
				}
	}
	Sleep(1500);
}