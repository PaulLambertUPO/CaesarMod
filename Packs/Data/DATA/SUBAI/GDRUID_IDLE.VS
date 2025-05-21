// void, Obj This

Druid this;
Unit tgt;
int  revitalize_amount, revitalize_stamina_cost, learn_stamina_cost;
int ghoul_summoning_stamina_cost;
point ptStart;
Building bldEnter;
int action; // 4 - revitalize, 3 - learn
bool bSuccess;
int learntimes;
bool bCanRevitalize, bCanLearn;

this = This.AsDruid();
if (!.IsValid) return;
while (!.Stop(1000));

ptStart = .posRH;
if (!.InShip && .InHolder) 
	bldEnter = .GetHolderSett.GetCentralBuilding;

revitalize_amount = GetConst("RevitalizeAmount");
revitalize_stamina_cost = GetCmdStaminaCost("revitalize");
learn_stamina_cost = GetCmdStaminaCost("learn");
ghoul_summoning_stamina_cost = GetCmdStaminaCost("ghoul_summoning");

bCanRevitalize = .HasSpecial(revitalize);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

action = 4; // Revitalize
tgt = .FindUnitToRevitalize.AsUnit();

while (true) 
{
	//SLEEP 2000 IF INACTIVE
	if (.hero.IsValid) if (.hero.command=="teleport")
	{
		Sleep(2000);
		continue;
	}
	if (!.AI) if(.InHolder || !.IsVisible)
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

	//AI COMBAT MAGIC
	if (.AI)
	{
		if (.stamina >= ghoul_summoning_stamina_cost)
		if (AIVar(.player, AIV_CombatMagic) != 0)
		if (!.InHolder)
		if (rand(8) == 1)
		if (IsResearched(.player, "Ghoul Summoning"))
		{
			point pt; pt = .BestMDPos(250, 0, 1000, 500, false);
			if (pt.x >= 0)
			{
				.AddCommand(true, "ghost", .pos);
				return;
			}
		}
	}
	// REVITALIZING / LEARNING
	learntimes = 0;
	while (learntimes < 10) 
	{
		//BAD POTENTIALITIES
		if (action == 4) if (!bCanRevitalize) break;
		if (action == 3) if (!bCanLearn) break;

		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible)   break;
		if (tgt.DistTo(ptStart) > .range + .sight) if (!.hero.IsValid || .hero != tgt.hero) break;

		//EARLY BREAK IF REVITALIZING CAN NOT BE DONE, AND REVITALIZE IS THE CURRENT ACTION
		if (action == 4) {
			if (tgt.stamina >= tgt.maxstamina) break;
			if (.stamina < revitalize_stamina_cost) break;
		}
		//EARLY BREAK IF LEARNING CAN NOT BE DONE AND LEARN IS THE CURRENT ACTION
		if (action == 3) {
			if (tgt.experience <= .experience) break;
			if (.IsEnemyInSquadSight) break;
			if (.stamina < learn_stamina_cost) break;
		}

		//GOING NEAR TARGET
		if (!.InRange(tgt) || .InHolder)
		{
			if (!.hero.IsValid) if (.DistTo(ptStart) > .sight)
				break;
			.GotoAttack(tgt, 2000, false, 2500);
			continue;
		}

		if (action == 4)
		{	// REVITALIZE
			.StartAnim(17, tgt.pos);
			Sleep(.TimeToActionMoment());
			
			if (tgt.IsAlive)
			if (tgt.stamina < tgt.maxstamina)
			if (!tgt.InHolder)
			if (.CanSee(tgt))
			if (.stamina >= revitalize_stamina_cost)
			{
				.SetStamina(.stamina - revitalize_stamina_cost);
				tgt.HealStamina(revitalize_amount);
				CreateFeedback("StaminaBoost", tgt);
			}
			Sleep(.TimeToAnimFinish());
			bSuccess = true;
			continue;
		}
		if (action == 3)
		{	//LEARN
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
				.SetStamina(.stamina - learn_stamina_cost);
				.SetExperience(exp);
				CreateFeedback("Experience", this);
			}
			Sleep(.TimeToAnimFinish());
			learntimes += 1;
			bSuccess = true;
			continue;
		}
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
		if (.IsEnemyInSquadSight && bCanRevitalize)
			action = 4; // REVITALIZE ONLY
		else if (!bSuccess || action == 3)
			action = 7 - action;//4, 3, 4, 3, .......
		if (action == 4 && !bCanRevitalize) action = 3;
		if (action == 3) {
			if (!bCanLearn) 
				if (EnvReadString(.player, "Ritual Chamber") == "researched" && (.race==Gaul || .race==Britain || .race == Germany) )
					bCanLearn = true;
			if (!bCanLearn)
				action = 4;
		}
		
		if (action == 4)
			tgt = .FindUnitToRevitalize.AsUnit();
		else
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
