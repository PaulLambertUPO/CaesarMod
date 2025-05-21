// void, Obj me, Obj u

Unit this;
Building b;
bool bEnemy;

this = me.AsUnit;
if( !this.IsValid )
	return;

if (.player == u.player) {
	Sleep(15);
	return;
}

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

b = u.AsBuilding;


if (b.IsValid() ) 
{
	if (b.settlement.GetCentralBuilding().IsValid()) {
		b = b.settlement.GetCentralBuilding();
		u = b;
	}

	// independent outposts & teuton tents
	while (1) {
		int range;
		if (b.settlement.IsOutpost()) {
			if (!b.settlement.IsIndependent()) break;
			range = b.range;
		} else {
			if (!b.IsHeirOf("TTent")) break;
			range = b.sight;
		}

		while (.DistTo(b.pos) > range) {
			if (.Goto(b, 0, 1237, false, 0)) break;
			if (.player == b.player) return;
		}

		.SetVisible(true);
		if (.HasSpecial(sneak)) .SetLastAttackTime();
		
		while (1) {
			if (.BestTargetInSquadSight().IsAlive()) {
				.AddCommand(true, "capture", b);
				.AddCommand(true, "engage");
				return;
			}
			.Goto(b.pos + b.pos - .pos, 0, 751, true, 0);
			if (.player == b.player) return;
		}
	}


	while(u.IsAlive() && .IsValidCaptureTarget(u))
	{
		if(.player == u.player) return;
		if(.Goto(u, 250, 5000, true, 2500))
		{
			if(.player == b.player) return;
			/*
			// units can't capture allied human settlements until allied player is not been eliminated
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
				if (b.settlement.loyalty==0) {
					b.settlement.SetPlayer(.player);
					b.settlement.SetLoyalty(11);
					return;
				}
				if (.IsEnemy(b) || b.IsEnemy(this))
					UserNotification("building attacked", "", b.pos, b.player);
				if(!.IsVisible)
					.SetVisible(true);
				if (.HasSpecial(sneak)) .SetLastAttackTime(); // mountaineer patch
					.Face(b.pos);
				
				//fixing imountaineer here. See imountaineer_behavior.vs for details
				//if (!.GetFlags(spec_charge))
				//	.SetLastAttackTime();
				
				.Taunt(2000);

				b.settlement.DecreaseLoyalty(1);
			}
		}
	}
} 
else if( u.IsHeirOf("Wagon") ) 
{
	Wagon w;
	w = u.AsWagon;
	while( w.IsAlive )
	{
		if(.Goto(u, 150, 5000, true, 2500))
		{
			if (!w.IsAlive) return;
			if (.player == u.player) return;
			// units can't capture allied human wagon until allied player is not been eliminated
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
			if (.HasSpecial(sneak)) .SetLastAttackTime(); // mountaineer patch
			.Face(w.pos);
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
			// units can't capture allied human horse until allied player is not been eliminated
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


Sleep(15);