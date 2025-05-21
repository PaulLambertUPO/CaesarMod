// void, Obj me

	Unit this;
	Obj u;

	this = me.AsUnit();

	if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
		.SetParryMode(false);

	//pr("engage: searching for new enemy");
	u = .BestTargetInSquadSight();
	if(u.IsAlive())	
	{
		//pr("engage: target found!");
		while (u.IsAlive() && .IsValidTarget(u)) 
		{
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
				while (.Attack(u));
			}
			u = .BestTargetInSquadSight();
		}
	} 
