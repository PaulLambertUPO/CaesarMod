// void, Obj This

// this script is used by CShaman and TEnchantress!!!

Druid this;
Unit tgt;
int learntimes;
int action;//2 - Cripple, 3 - LEARN
int i;
bool bSuccess;
int cripple_stamina_cost, learn_stamina_cost;
bool bCanCripple, bCanLearn;
Obj hInvalid;

this = This.AsDruid();
if (!.IsValid)
	return;

cripple_stamina_cost = GetCmdStaminaCost("cripple");
learn_stamina_cost = GetCmdStaminaCost("learn");

bCanCripple = .HasSpecial(cripple);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

while (!.Stop(1000));

action = 2;
tgt = .GetBestCrippleTarget.AsUnit;

while (true) 
{
	if (tgt.IsDead) tgt = hInvalid; /// avoid handle reuse problems

	if(.InHolder || !.IsVisible)
	{
		Sleep(2000);
		continue;
	}

	bSuccess = false;
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
		if (!.IsVisible)   break;
		if (!.InRange(tgt)) break;

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

		if (action == 2)
		{	//cripple
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
		break;
	}

	.Idle(1000);
	if (.IsEnemyInSquadSight)
		action = 2;//Cripple
	else if (!bSuccess || action == 3)
		action = 5 - action;
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
}
