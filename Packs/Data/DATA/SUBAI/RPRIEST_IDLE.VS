// void, Obj This

//THIS SCRIPT IS SHARED BY THE ROMAN/GREEK PRIEST AND THE GAUL DRUID
Druid this;
Unit tgt;
int  amount, heal_stamina_cost, learn_stamina_cost;
int i;
point ptStart;
Building bldEnter;
int action;//1 - heal, 3 - learn
bool bSuccess;
int learntimes;
bool bCanHeal, bCanLearn;
Obj hInvalid;

this = This.AsDruid();
if (!.IsValid) return;
while (!.Stop(1000));

ptStart = .posRH;
if (!.InShip && .InHolder) 
	bldEnter = .GetHolderSett.GetCentralBuilding;

heal_stamina_cost = GetCmdStaminaCost("heal");
learn_stamina_cost = GetCmdStaminaCost("learn");

bCanHeal = .HasSpecial(healing);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race==Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

action = 1;//HEAL
tgt = .FindUnitToHeal;

while (true) 
{
	if (tgt.IsDead) tgt = hInvalid; /// avoid handle reuse problems

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
	if (!.IsVisible) if (.IsEnemyInSquadSight) {
		bool bStayHidden = true;
		if (.hero.IsValid) if (.hero.command == "attack" || .hero.command == "engage")
			bStayHidden = false;
		if (bStayHidden) {
			Sleep(2000);
			continue;
		}
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

	/*//AI COMBAT MAGIC
	if (.AI) if (AIVar(.player, AIV_CombatMagic) != 0) if (rand(8) == 1)
	{
		if (.race == Gaul) if (!.InHolder) if (IsResearched(.player, "Ghoul Summoning"))
		{
			point pt; pt = .BestMDPos(250, 0, 1000, 500, false);
			if (pt.x >= 0)
			{
				.AddCommand(true, "ghost", .pos);
				return;
			}
		}
		if (.race == ImperialRome || .race == RepublicanRome) if (IsResearched(.player, "Cloud of Plague"))
		{
			point pt; pt = .BestMDPos(100, 200, 1500, 1000, true);
			if (pt.x >= 0)
			{
				int mist_range; mist_range = GetConst("MistRange");
				if (.Goto(pt, mist_range, 2000, false, 2500))
				{
					.AddCommand(true, "mist");
					return;
				}
				continue;
			}
		}
	}
	*/

	//HEALING/LEARNING
	learntimes = 0;
	while (learntimes < 10) 
	{
		//BAD POTENTIALITIES
		if (action == 1) if (!bCanHeal) break;
		if (action == 3) if (!bCanLearn) break;

		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible) if (.IsEnemyInSquadSight)
		{
			if (!.hero.IsValid) break;
			if (.hero.command != "attack" && .hero.command != "engage") break;
		}
		if (tgt.DistTo(ptStart) > .range + .sight) if (!.hero.IsValid || .hero != tgt.hero)
			break;

		//EARLY BREAK IF HEALING CAN NOT BE DONE, AND HEAL IS THE CURRENT ACTION
		if (action == 1) {
			if (tgt.health >= tgt.maxhealth) break;
			if (.stamina < heal_stamina_cost) break;
		}
		//EARLY BREAK IF LEARNING CAN NOT BE DONE AND LEARN IS THE CURRENT ACTION
		if (action == 3) {
			if (tgt.experience <= .experience) break;
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

		if (action == 1)
		{	//HEAL
			.StartAnim(17, tgt.pos);
			Sleep(.TimeToActionMoment());
			
			if (tgt.IsAlive)
			if (tgt.health < tgt.maxhealth)
			if (!tgt.InHolder)
			if (.CanSee(tgt))
			if (.stamina >= heal_stamina_cost)
			{
				.SetVisible(true); .SetLastAttackTime();
				.SetStamina(.stamina - heal_stamina_cost);
				amount = GetConst("HealAmount") + .level;
				tgt.Heal(amount);
				CreateFeedback("Heal", tgt);
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
				.SetVisible(true); .SetLastAttackTime();
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
		if (.IsEnemyInSquadSight && bCanHeal)
			action = 1; //HEAL ONLY
		else if (!bSuccess || action == 3)
			action = 4 - action;//1, 3, 1, 3, .......
		for (i = 0; i < 2; i += 1) {
			if (action == 1 && !bCanHeal) action = 3;
			if (action == 3) {
			    if (!bCanLearn)
				  if (EnvReadString(.player, "Ritual Chamber") == "researched" && (.race==Gaul || .race==Britain|| .race == Germany))
					bCanLearn = true;
				if (!bCanLearn)
					action = 1;
			}
			if (tgt.IsValid) break;
			if (!bCanHeal || !bCanLearn) break;
			action = 4 - action;
		}
		
		if (action == 1)
			tgt = .FindUnitToHeal;
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
