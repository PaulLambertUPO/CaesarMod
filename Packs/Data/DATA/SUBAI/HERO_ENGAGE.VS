// void, Obj This

Hero this;
Obj u, u2;
point ptStart;
bool bSquadTarget;
int i;


this = This.AsHero;
ptStart = .pos;

//.pr("hero::engage: looking for enemies");

while (1)
{
	bSquadTarget = false;
	if (.IsEnemyInSquadSight())
	{
		u = .BestTargetInSquadSight();
		if (u.IsAlive())
			bSquadTarget = true;
		for (i = 0; !bSquadTarget && i < .army.count; i += 1) {
			u2 = .army[i].AsUnit.BestTargetInSquadSight();
			if (u2.IsAlive())
				bSquadTarget = true;
		}		
	}
	if (!bSquadTarget)
		break; // there is no enemy we could fight
	for (i = 0; i < .army.count; i += 1) {
		if (.army[i].command != "engage")
			.army[i].SetCommand("engage");
	}
	if (!u.IsAlive()) {
		Sleep(217);
	}
	while (u.IsAlive())
	{
		//.pr("hero::engage: chasing");
		while (!.GotoAttack(u, 1500, false, 15000))
		{
			u = .BestTargetInSquadSight;
			if (!u.IsAlive) break;
			if (!.IsValidTarget(u)) break;
			if (.DistTo(ptStart) > 1000)
				break;
		}

		//.pr("hero::engage: fighting");
		if (u.IsAlive)
		if (.IsValidTarget(u))
			while (.Attack(u));

		//if (GetTime - nStartTime > 1000) break;

		u = .BestTargetInSquadSight;
		if (!u.IsAlive)	break;
		if (!.IsValidTarget(u))	break;
		if (.DistTo(ptStart) > 1000)
			break;
	}
	
	while (!.Stop(1000));
	//.pr("hero::engage: enemies killed");
}

Sleep(500); // Else the sneak command cycles, because of the delayed update of enemies in 'BestTargetInSquadSight'
