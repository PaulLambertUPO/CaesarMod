// void, Obj me, Obj u

Hero this;
Building b;
int i, nRange;
bool bEnemy;

this = me.AsHero;
if (!.IsValid)
	return;
nRange = .sight * 2 / 3;
b = u.AsBuilding;
if (b.IsValid)
{
	if (b.settlement.GetCentralBuilding().IsValid()) {
		b = b.settlement.GetCentralBuilding();
		u = b;
	}

	// capture building
	if (b.settlement.IsOutpost())
		if (b.settlement.IsIndependent())
			return;

	if (.player == u.player)
		return;
	//all checks are player based, not relation based, to allow capture of allied settlements
	//move near the building
	if (.PathTo(b, .FormRadius, 0) > nRange)
	{
		.FormSetupAndMoveTo(b, 100, 100, false);
		while (.HasPath && .DistTo(b) > nRange && .IsAlive && .IsValidCaptureTarget(b))
			.FormKeepMoving(1500);
	}
	if (.player == u.player)
		return;

	//command the army first
	.army.ClearDead;
	for (i = 0; i < .army.count; i += 1)
		if (.army[i].IsValidCaptureTarget(b))
			.army[i].SetCommand("capture", b);
		else
			.army[i].SetCommand("idle");
		
	while (u.IsAlive && .player != u.player && .IsValidCaptureTarget(u))
		if (.Goto(u, 250, 5000, true, 2500))
		{
			if(.player == b.player) return;
			/*
			// heroes can't capture allied human settlements until allied player is not been eliminated
			if( (DiplAreAllied(.player(), b.player()) == true) && (EnvReadInt(b.player(), "elimination") != 1) && (IsAIPlayer(b.player()) == false) )
			{
				return;
			}
			*/
			bEnemy = .IsEnemy(u);
			if (!bEnemy)
			if (!u.IsEnemy(this))
			{
				b.settlement.SetPlayer(.player);
				return;
			}
			while (bEnemy == .IsEnemy(u)) {
				if (b.settlement.loyalty == 0) {
					b.settlement.SetPlayer(.player);
					b.settlement.SetLoyalty(11);
					return;
				}
				if (.IsEnemy(b) || b.IsEnemy(this))
					UserNotification("building attacked", "", b.pos, b.player);
				if (!.IsVisible)
					.SetVisible(true);
				.Face(b.pos);
				/// command the idle army -> new attached units and such that have been attacked in the meantime
				for (i = 0; i < .army.count; i += 1)
					if (.army[i].command == "idle")
						if (.army[i].IsValidCaptureTarget(b))
							.army[i].SetCommand("capture", b);
				.Taunt(2000);
				b.settlement.DecreaseLoyalty(1);
			}
		}
}
else if( u.IsHeirOf("Wagon") ) 
{
	Wagon w;
	w = u.AsWagon;

	.army.ClearDead;
	for (i=0; i<.army.count; i+=1)
		.army[i].SetCommand("capture", u);
			
	while( w.IsAlive && !w.InHolder )
	{
		if(.player == w.player) return;
		if(.Goto(u, 150, 5000, true, 2500))
		{
			if (!w.IsAlive) return;
			if (.player == u.player) return;
			// heroes can't capture allied human wagon until allied player is not been eliminated
			if( (DiplAreAllied(.player(), w.player()) == true) && (EnvReadInt(w.player(), "elimination") != 1) && (IsAIPlayer(w.player()) == false) )
			{
				return;
			}
			if (!u.IsEnemy(me))
			if (!me.IsEnemy(u))
			{
				w.SetPlayer(.player);
				return;
			}
			if (w.loyalty==0) {
				w.SetPlayer(.player);
				return;
			}
			if (.IsEnemy(w) || w.IsEnemy(this))
				UserNotification("unit attacked", "", w.pos, w.player);
			if(!.IsVisible)
				.SetVisible(true);
			.Face(w.pos);
			/// command the idle army -> new attached units and such that have been attacked in the meantime
			for (i = 0; i < .army.count; i += 1)
				if (.army[i].command == "idle")
					.army[i].SetCommand("capture", u);
			.Taunt(2000);
			w.DecreaseLoyalty(1);
		}
	}
}
else if(u.IsHeirOf("WildHorse") == true) 
{
	Unit wildHorse;
	wildHorse = u.AsUnit();
	
	//Per poter catturare un cavallo è necessario aver sbloccato la tecnologia "Tame horses" da ITavern.
	if(EnvReadString(.player(), "Tame horses") != "researched")
	{
		Sleep(100);
		return;
	}
	
	while(wildHorse.IsAlive() == true)
	{
		if(.Goto(wildHorse, 150, 5000, true, 2500))
		{
			if(wildHorse.IsAlive() == false) 
				return;
			if(.player() == wildHorse.player()) 
				return;
			// heroes can't capture allied human horse until allied player is not been eliminated
			if( (DiplAreAllied(.player(), wildHorse.player()) == true) && (EnvReadInt(wildHorse.player(), "elimination") != 1) && (IsAIPlayer(wildHorse.player()) == false) )
			{
				return;
			}
			if(wildHorse.IsEnemy(this) == false)
			if(.IsEnemy(wildHorse) == false)
			{
				wildHorse.SetPlayer(.player);
				return;
			}
			if(.IsEnemy(wildHorse) == true || wildHorse.IsEnemy(this) == true)
				UserNotification("unit attacked", "", wildHorse.pos(), wildHorse.player());
			if(.IsVisible() == false)
			{
				.SetVisible(true);
			}
			if(.HasSpecial(sneak) == true) 
			{
				.SetLastAttackTime(); // mountaineer patch
			}
			.Face(wildHorse.pos());
			.Taunt(2000);
			
			wildHorse.SetPlayer(.player());
			if(.IsAlive() == true)
			{
				wildHorse.SetCommand("move", .pos());
			}
			else
			{
				wildHorse.SetCommand("idle");
			}
			UserNotification("horse captured", "", wildHorse.pos(), wildHorse.player());
			Sleep(100);
			return;
		}
	}
}