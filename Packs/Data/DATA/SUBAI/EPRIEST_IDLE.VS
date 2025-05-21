// void, Obj This

Druid this;
Unit tgt;
point ptStart;
Building bldEnter;
bool bSuccess;
int action;
int i;
int learntimes;
int cripple_stamina_cost, learn_stamina_cost;
bool bCanCripple, bCanLearn;
Obj hInvalid;

this = This.AsDruid();
if (!.IsValid) return;
while (!.Stop(1000));

action = 2;
ptStart = .posRH;
if (!.InShip && .InHolder) 
	bldEnter = .GetHolderSett.GetCentralBuilding;

cripple_stamina_cost = GetCmdStaminaCost("cripple");
learn_stamina_cost = GetCmdStaminaCost("learn");

bCanCripple = .HasSpecial(cripple);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

tgt = .GetBestCrippleTarget.AsUnit;

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
	if (!.IsVisible)
	{
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

	//Cripple/LEARN
	learntimes = 0;
	while (learntimes < 10)
	{
		//BAD POTENTIALITIES
		if (action == 2) if (!bCanCripple) break;
		if (action == 3) if (!bCanLearn) break;
		
		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible)
		{
			if (!.hero.IsValid) break;
			if (.hero.command != "attack" && .hero.command != "engage") break;
		}
		if (tgt.DistTo(ptStart) > .range + .sight) break;

		//EARLY BREAK IF TEACH CAN NOT BE DONE, AND TEACH IS THE CURRENT ACTION
		if (action == 2) {
			if (tgt.stamina <= 0) break;
			if (!.IsEnemy(tgt)) break;
			if (.stamina < cripple_stamina_cost) break;
		}

		//EARLY BREAK IF LEARNING CAN NOT BE DONE AND LEARN IS THE CURRENT ACTION
		if (action == 3) {
			if (tgt.experience <= .experience) break;
			if (.IsEnemy(tgt)) break;
			if (.stamina < learn_stamina_cost) break;
		}

		//GOING NEAR TARGET
		if (!.InRange(tgt) || .InHolder) 
		{
			if (!.hero.IsValid) if(.DistTo(ptStart) > .sight)
				break;
			.GotoAttack(tgt, 2000, false, 2500);
			continue;
		}

		if (action == 2)
		{	//Cripple
			.StartAnim(17, tgt.pos);
			Sleep(.TimeToActionMoment());

			if (tgt.IsAlive)
			if (.IsEnemy(tgt))
			if (.CanSee(tgt))
			if (.stamina >= cripple_stamina_cost)
			if (!tgt.InHolder)
			if (.CanSee(tgt))
			{
				.SetVisible(true); .SetLastAttackTime();
				.SetStamina(.stamina - cripple_stamina_cost);
				tgt.SetStamina(0);
				CreateFeedback("StaminaLoss", tgt);
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
			if (!.IsEnemy(tgt))
			{
				int exp;
				exp = .experience + (.inherentlevel + 3) / 4;
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

	if (.InHolder) {
		Sleep(2113);
		continue;
	}

	if (.hero.IsValid)
	{
		if (.DistTo(.hero.dest)>250)
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
	{
		if (.IsEnemyInSquadSight)
			action = 2;//CRIPPLE
		else if (!bSuccess|| action == 3) {
			action = 5 - action;//2, 3, 2, 3, .....
		}
		for (i = 0; i < 2; i += 1) {
			if (action == 2 && !bCanCripple) action = 5;
			if (action == 5 && !bCanLearn) action = 2;
			if (action == 2)
				tgt = .GetBestCrippleTarget.AsUnit;
			else
				tgt = .FindUnitToLearn.AsUnit;
			if (tgt.IsValid) break;
			if (!bCanCripple || !bCanLearn) break;
			action = 5 - action;
		}

		if(tgt.IsAlive()) if(tgt.DistTo(ptStart) - .range < .sight)
		{
			.GotoAttack(tgt, 2000, false, 2500);
			break;
		}
		
		if (.hero.IsValid)
			break;
		if (bldEnter.IsValid) {
			if (!.IsEnemy(bldEnter)) {
				point pt; pt = bldEnter.GetEnterPoint(this);
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
