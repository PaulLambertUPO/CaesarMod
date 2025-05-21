// void, Obj This

Druid this;
Unit tgt;
int  revitalize_amount, revitalize_stamina_cost, learn_stamina_cost;
int ghoul_summoning_stamina_cost;
int action; // 4 - revitalize, 3 - learn
bool bSuccess;
int learntimes;
bool bCanRevitalize, bCanLearn;

this = This.AsDruid();

revitalize_amount = GetConst("RevitalizeAmount");
revitalize_stamina_cost = GetCmdStaminaCost("revitalize");
learn_stamina_cost = GetCmdStaminaCost("learn");
ghoul_summoning_stamina_cost = GetCmdStaminaCost("ghoul_summoning");

bCanRevitalize = .HasSpecial(revitalize);
bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

action = 4; //Revitalize
tgt = .FindUnitToRevitalize.AsUnit();

while (true) 
{
	if(.InHolder || !.IsVisible)
	{
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
		if (!.IsVisible)   break;
		if(!.InRange(tgt)) break;

		if (action == 4)
		{ // REVITALIZE
			if (!bCanRevitalize) break;
			if (tgt.stamina >= tgt.maxstamina) break;
			if (.stamina < revitalize_stamina_cost) break;
			
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
			if (!bCanLearn) break;
			if (tgt.experience <= .experience) break;
			if (.IsEnemyInSquadSight) break;
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
	if (.IsEnemyInSquadSight && bCanRevitalize)
		action = 4;
	else if (!bSuccess || action == 3)
		action = 7 - action;
	if (action == 4 && !bCanRevitalize) action = 3;
	if (action == 3) {
		if (!bCanLearn) if (EnvReadString(.player, "Ritual Chamber") == "researched" && (.race==Gaul || .race==Britain || .race == Germany))
			bCanLearn = true;
		if (!bCanLearn)
			action = 4;
	}

	if (action == 4)
		tgt = .FindUnitToRevitalize.AsUnit();
	else
		tgt = .FindUnitToLearn.AsUnit();
}
