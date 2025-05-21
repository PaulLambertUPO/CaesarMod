// void, Obj This, Obj target

Druid this;
Unit tgt;
int  exp, stamina_cost;

this = This.AsDruid();
if (!.IsAlive)
	return;
if (.race == Gaul || .race == Britain || .race == Germany) if (EnvReadString(.player, "Ritual Chamber") != "researched")
	return;
	
stamina_cost = GetCmdStaminaCost("learn");

tgt = target.AsUnit();

while (tgt.IsValid())
{
	while (tgt.IsAlive())
	{
		if (.IsEnemy(tgt) || !.CanSee(tgt) || tgt.experience <= .experience ||
		    tgt.InHolder() || .InHolder() || target.AsShip.IsValid())
		{
			Sleep(513);
			break;
		}
		if (!.InRange(tgt)) {
			.GotoAttack(tgt, 5000, false, 2500);
			continue;
		}
		if (.stamina < stamina_cost) {
			Sleep(200);
			continue;
		}
		.StartAnim(19, tgt.pos);
		Sleep(.TimeToActionMoment());
		if (tgt.IsAlive()) // fix the full expression evaluation
		if (!.IsEnemy(tgt) && .CanSee(tgt) && tgt.experience > .experience && !tgt.InHolder() && !.InHolder())
		{
			exp = .experience + (.inherentlevel + 3) / 4;
			if (exp > tgt.experience) exp = tgt.experience;
			.SetVisible(true); .SetLastAttackTime();
			.SetStamina(.stamina - stamina_cost);
			.SetExperience(exp);
			CreateFeedback("Experience", this);
		}
		Sleep(.TimeToAnimFinish());
	}

	tgt = .FindUnitToLearn;
}
