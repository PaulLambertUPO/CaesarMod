// void, Obj me

	Unit this;
	Obj u;
	bool melee;

	this = me.AsUnit();
	melee = !.IsRanged;

	if (.IsValid) // leave parry mode at new command
	.SetParryMode(false);

	//pr("engage: searching for new enemy");
	u = .BestTargetInSquadSight();
	if(u.IsAlive())	
	{
		//pr("engage: target found!");
		while (u.IsAlive() && .IsValidTarget(u) ) 
		{
			if (!u.IsMilitary() && !u.IsHeirOf("BaseMage"))
				break;
			Sleep(rand(80) + 20); // Disperse the times
			while(!.GotoAttack(u, 1500, true, 15000)) 
			{
				//pr("engage: approaching target!");
				u = .BestTargetInSquadSight();
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
			}
			//pr("engage: attacking target!");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				if (u.AsCatapult().IsValid) {
					while (.Attack(u))
						if (melee)
							if (.HasSpecial(trample))
								u.Damage(.damage);
				}
				while (.Attack(u))
					;
			}
			u = .BestTargetInSquadSight();
		}
	} 
