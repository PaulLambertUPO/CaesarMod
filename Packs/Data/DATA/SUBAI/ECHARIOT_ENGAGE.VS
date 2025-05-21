// void, Obj me

Unit this;
Obj u;
bool disease_shot;
int disease_cost;
int k;

this = me.AsUnit();

disease_cost = GetConst("DiseaseCost");

if (.stamina >= disease_cost)
	u = .BestTargetInSquadSight_PreferUndiseased();
else
	u = .BestTargetInSquadSight();

while (u.IsAlive() && .IsValidTarget(u)) {
	Sleep(rand(80) + 50); // Disperse the times
	while(!.GotoAttack(u, 1471, true, 15000)) {
		//pr("engage: approaching target!");
		if (.stamina >= disease_cost)
			u = .BestTargetInSquadSight_PreferUndiseased();
		else
			u = .BestTargetInSquadSight();
		if(!u.IsAlive() || !.IsValidTarget(u)) break;
	}

	//pr("engage: attacking target!");
	if (u.IsAlive() && .IsValidTarget(u)) {
		disease_shot = false;
		if (.stamina >= disease_cost)
		if (u.AsUnit().IsValid()) {
			disease_shot = true;
			if (u.AsUnit().IsDiseased())
				disease_shot = false;
		}
		if (disease_shot)
			.Attack(u);
		else {
			for (k = 0; k < 4; k += 1)
				if (!.Attack(u))
					break;
		}
	}

	if (.stamina >= disease_cost)
		u = .BestTargetInSquadSight_PreferUndiseased();
	else
		u = .BestTargetInSquadSight();
}
