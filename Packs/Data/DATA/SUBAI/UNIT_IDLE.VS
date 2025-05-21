// void, Obj me

Unit this, u;
point pt;
this = me.AsUnit();

while (!.Stop(1000));

//.pr("idle: started");
while(1)
{
	u = .BestTargetInSquadSightMisZeroDamage;
	if(.IsVisible)
	if(u.IsAlive())
	{
		bool bEngage = false;
		if (u.attack > 0) bEngage = true;
		else if (u.AsDruid.IsValid()) bEngage = true;
		else if (u.AsWagon.IsValid()) bEngage = true;
		if (bEngage)
		{	//pr("found enemy!");
			.AddCommand( true, "engage");
			return;
		}
	}
	{
		//.pr("idle: no enemy in sight");
		if (.Stop(2000))
		{
			//.pr("idle: doing nothing");
			if (.hero.IsValid)
			if (.hero.GetHolderSett.IsValid)
			if (!(.hero.GetHolderSett == .GetHolderSett))
			if (!.hero.GetHolderSett.GetCentralBuilding.IsHeirOf("BaseRuins"))
			if (EnvReadString(.hero.GetHolderSett, "autotrain") != "on"
					|| .inherentlevel >= EnvReadInt(.hero.GetHolderSett, "MaxAutotrainLevel"))
			{
				.AddCommand(true, "enter", .hero.GetHolderSett.GetCentralBuilding);
				return;
			}

			if (.AI)
			if (!.hero.IsValid)
			if (!.InHolder)
			if (IsWaterLsa(GetGAIKA(this).LSA))
			{	/// leave the coast
				pt.Set(.pos.x + (150 - rand(300)), .pos.y + (150 - rand(300)));
				if (pt.InRect(GetMapRect))
				if (IsPassable3x3(pt))
				if (!IsWaterLsa(pt.GetGAIKA.LSA))
				{
					.AddCommand(true, "move", pt);
					return;
				}
			}

			.Idle(1900 + rand(100));
			if (rand(10)==0) {
				pt = .GetDir();
				if (pt.x!=0 || pt.y!=0) {
					pt.SetLen(100);
					pt.Rot(rand(60)-30);
					.Face(pt + .posRH);
				}
			}
		}
	}
}