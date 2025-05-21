// void, Obj This

Druid this;
Unit tgt;
int  amount, heal_stamina_cost, learn_stamina_cost;
int action;//1 - HEAL, 3 - LEARN
int i;
bool bSuccess;
int learntimes;
bool bCanHeal, bCanLearn;
Obj hInvalid;

this = This.AsDruid();

heal_stamina_cost = GetCmdStaminaCost("heal");
learn_stamina_cost = GetCmdStaminaCost("learn");

bCanHeal = .HasSpecial(healing);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

while (!.Stop(1000));

action = 1;//HEAL
tgt = .FindUnitToHeal.AsUnit();

while (true) 
{
	if (tgt.IsDead) tgt = hInvalid; /// avoid handle reuse problems

	if(.InHolder)
	{
		Sleep(2000);
		continue;
	}
	if (!.IsVisible) //if (.IsEnemyInSquadSight)
	{	// do not show up in stand ground
		Sleep(2000);
		continue;
	}

	bSuccess = false;
	learntimes = 0;
	while (tgt.IsAlive() && learntimes < 10) 
	{
		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible) if (.IsEnemyInSquadSight) break; // do not show up if enemies around
		if(!.InRange(tgt)) break;

		if (action == 1)
		{//HEAL
			if (!bCanHeal) break;
			if (tgt.health >= tgt.maxhealth) break;
			if (.stamina < heal_stamina_cost) break;
			
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
		else if (action == 3)
		{//LEARN
			if (!bCanLearn) break;
			if (tgt.experience <= .experience) break;
			if (.stamina < learn_stamina_cost) break;

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
		break;
	}

	.Idle(1000);
	if (.IsEnemyInSquadSight && bCanHeal)
		action = 1;
	else if (!bSuccess || action == 3)
		action = 4 - action;
	for (i = 0; i < 2; i += 1) {
		if (action == 1 && !bCanHeal) action = 3;
		if (action == 3) {
			if (!bCanLearn) if (EnvReadString(.player, "Ritual Chamber") == "researched" && (.race==Gaul || .race==Britain || .race==Germany))
				bCanLearn = true;
			if (!bCanLearn)
				action = 1;
		}
		if (tgt.IsValid) break;
		if (!bCanHeal || !bCanLearn) break;
		action = 4 - action;
	}

	if (action == 1)
		tgt = .FindUnitToHeal.AsUnit();
	else
		tgt = .FindUnitToLearn.AsUnit();
}
