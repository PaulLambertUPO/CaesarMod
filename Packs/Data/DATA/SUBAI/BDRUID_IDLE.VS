// void, Obj This

Druid this;
Unit tgt;
int  learn_stamina_cost;
point ptStart;
Building bldEnter;
bool bSuccess;
int learntimes;
bool  bCanLearn;

this = This.AsDruid();

ptStart = .posRH;
if (!.InShip && .InHolder) 
	bldEnter = .GetHolderSett.GetCentralBuilding;

learn_stamina_cost = GetCmdStaminaCost("learn");

bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

tgt = .FindUnitToLearn.AsUnit();

while (true) 
{
	//SLEEP 2000 IF INACTIVE
	if (.hero.IsValid) if (.hero.command=="teleport")
	{
		Sleep(2000);
		continue;
	}
	if (!.AI) if(.InHolder)
	{
		Sleep(2000);
		continue;
	}

	bSuccess = false;
	if (.hero.IsValid) if (!.hero.InHolder)
	{//GO NEAR HERO IF TOO FAR
		if (.DistTo(.hero) > 250)
		{
			.Goto(.hero, 250, 2000, false, -1);
			ptStart = .pos;
			continue;
		}
	}
	else
	{//GO NEAR STARTPOINT IF TOO FAR
		if (.DistTo(ptStart) > .sight)
		{
			.Goto(ptStart, .sight, 2000, false, -1);
			continue;
		}
	}

	learntimes = 0;
	while (learntimes < 10) 
	{
		//BAD POTENTIALITIES
		if (!bCanLearn) break;

		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible)   break;
		if (tgt.DistTo(ptStart) > .range + .sight) if (!.hero.IsValid || .hero != tgt.hero) break;

		//EARLY BREAK IF LEARNING CAN NOT BE DONE AND LEARN IS THE CURRENT ACTION
		if (tgt.experience <= .experience) break;
		if (.stamina < learn_stamina_cost) break;

		//GOING NEAR TARGET
		if (!.InRange(tgt) || .InHolder)
		{
			if (!.hero.IsValid) if (.DistTo(ptStart) > .sight)
				break;
			.GotoAttack(tgt, 2000, false, 2500);
			continue;
		}

		//LEARN
		.StartAnim(19, tgt.pos);
		Sleep(.TimeToActionMoment());
			
		if (tgt.IsAlive)
		if (tgt.experience > .experience)
		if (!tgt.InHolder)
		if (.CanSee(tgt))
		if (.stamina >= learn_stamina_cost)
		{
			int exp; exp = .experience + (.inherentlevel + 3) / 4;
			if (exp > tgt.experience) exp = tgt.experience;
			.SetVisible(true); .SetLastAttackTime();
			.SetStamina(.stamina - learn_stamina_cost);
			.SetExperience(exp);
			CreateFeedback("Experience", this);
		}
		Sleep(.TimeToAnimFinish());
		learntimes += 1;
		bSuccess = true;
		
		Sleep(1000);//just in case something went wrong
	}

	//INACTIVE -> SLEEP
	if (.InHolder) {
		Sleep(2000);
		continue;
	}

	if (.hero.IsValid)
	{//GO NEAR HERO
		if (.DistTo(.hero.dest) > 250)
		{
			if (.Goto(.hero.dest, 200, 2000, false, -1))
				.Idle(1000);
		}
		else
			.Idle(1000);
	}
	else
	{
		.Idle(1000);
	}


	while (1)
	{	//FIND NEW TARGET AND RETURN TO THE STARTPOS
		if (!bCanLearn) if (EnvReadString(.player, "Ritual Chamber") == "researched")
			bCanLearn = true;
		
		tgt = .FindUnitToLearn.AsUnit();
		if(tgt.IsAlive()) if(tgt.DistTo(ptStart) < .sight + .range)
		{
			.GotoAttack(tgt, 2000, false, 2500);
			break;
		}
		if (.hero.IsValid)
			break;
		if (bldEnter.IsValid) {
			if (!.IsEnemy(bldEnter)) {
				point pt;
				pt = bldEnter.GetEnterPoint(this);
				if (!.GotoEnter(pt, 0, 1000, true, 5000))
					continue;
				.AddCommand(true, "enter", bldEnter);
				return;
			} else {
				bldEnter.Clear;
				ptStart = .posRH;
			}
		}

		if (.AI)
		if (!.hero.IsValid)
		if (!.InHolder)
		if (IsWaterLsa(ptStart.GetGAIKA.LSA))
		{	/// leave the coast
			point pt;
			pt.Set(.pos.x + (128 - rand(256)), .pos.y + (128 - rand(256)));
			if (pt.InRect(GetMapRect))
			if (IsPassable3x3(pt))
			if (!IsWaterLsa(pt.GetGAIKA.LSA))
				ptStart = pt;
		}

		if(.Goto(ptStart, 0, 2000, true, 1000))
		{
			.Idle(2000);
			break;
		}
	}
}
