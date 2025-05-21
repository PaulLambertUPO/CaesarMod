// void, str GroupName, str TargetArea

// Guard AI Helper

Obj target;
Query qry;
int nCounter = 0;
int retreat_timeout = 0;

target = GetNamedObj(TargetArea).obj;
qry = Group(GroupName);
AttackArea(qry, TargetArea);

while (1)
{
	int i, j, nAwayDist;
	ObjList ol;

	ol = qry.GetObjList();
	for (i = 0; i < ol.count(); i += 1)
	{
		Obj obj; obj = ol[i];
		if (obj.AsUnit.hero.IsValid) continue;
		if (!obj.IsAlive()) continue;
		nAwayDist = AreaDistTo(obj.pos, TargetArea);

		if (nAwayDist > 500) {
			obj.SetCommand("move", GetRandomPointInArea(TargetArea));
		}
		else
			if (obj.command == "engage")
			{
				int nAttacker = 0;
				for (j = 0; j < ol.count(); j += 1)
					if (ol[j].AsUnit) if (ol[j].AsUnit.TimeWithoutAttack < 2500)
						nAttacker += 1;
				if (retreat_timeout == 0)
					retreat_timeout = 10;

				if (nAttacker > 2 || retreat_timeout > 2)
				{
					target = obj.AsUnit.BestTargetInSquadSight;
					nCounter = 20;
					if (retreat_timeout > 2)
						retreat_timeout -= 1;
				} else {
					//pr("Let's Get Back from Where we Started");
					ol.ClearDead();
					for (j = 0; j < ol.count(); j += 1)
						ol[j].SetCommand("move", GetRandomPointInArea(TargetArea));
					retreat_timeout = 0;
				}
			}
			else
			{
				if (nCounter > 0 && target.IsValid)
				{
					obj.AddCommand(true, "advance", target.pos);
					obj.KillCommand();
				} else
					if (obj.command == "idle" || obj.command == "stand_position")
					{
						point pt;
						pt = GetRandomPointInArea(TargetArea);
						obj.AddCommand(true, "advance", pt);
						obj.KillCommand();
					}
			}
		nCounter -= 1;
		if (ol.count/6 != 0) if ((i % (ol.count/6)) == 0)
			Sleep(750);
	}
	if (ol.count == 0)
		return;
	Sleep(1753);
}
