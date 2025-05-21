// void, Obj This

Druid this;
Unit tgt;
int learn_stamina_cost;
bool bSuccess;
int learntimes;
bool bCanLearn;

this = This.AsDruid();

learn_stamina_cost = GetCmdStaminaCost("learn");

bCanLearn = true;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	bCanLearn = false;

while (!.Stop(1000));

tgt = .FindUnitToLearn.AsUnit();
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

		//LEARN
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
	}

	.Idle(1000);
	if (!bCanLearn) if (EnvReadString(.player, "Ritual Chamber") == "researched")
		bCanLearn = true;
	tgt = .FindUnitToLearn.AsUnit();
}
