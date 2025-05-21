// void, Obj This

Druid this;
Unit tgt;
int level, level1, level2;
int learntimes;
int action;//2 - TEACH, 3 - LEARN
int i;
bool bSuccess;
int teach_stamina_cost, learn_stamina_cost;
bool bCanTeach, bCanLearn;
int chance, k;
Obj hInvalid;

this = This.AsDruid();
if (!.IsValid)
	return;
action = 2;

teach_stamina_cost = GetCmdStaminaCost("teach");
learn_stamina_cost = GetCmdStaminaCost("learn");

chance = GetConst("EnchantressTeachPercent");
if (IsResearched(.player, "Code of Valor"))
	chance += .level * GetConst("EnchantressTeachIncrease");
k = chance / 100;
chance = chance % 100;

bCanTeach = .HasSpecial(teaching);
bCanLearn = true;

//TO WHAT LEVEL SHOULD WE TRAIN UNITS?
level1 = GetConst("TeachingLevel1");
level2 = GetConst("TeachingLevel2");

while (!.Stop(1000));

level = level1;
if (EnvReadString(.player, "Ancestral Knowledge") == "researched")
	level = level2;
tgt = .FindUnitBelowILevel(level).AsUnit;

while (true) 
{
	if (tgt.IsDead) tgt = hInvalid; /// avoid handle reuse problems
	if(.InHolder || !.IsVisible)
	{
		Sleep(2000);
		continue;
	}

	//TO WHAT LEVEL SHOULD WE TRAIN UNITS?
	if (level < level2) if (EnvReadString(.player, "Ancestral Knowledge") == "researched")
		level = level2;

	bSuccess = false;
	learntimes = 0;
	while (learntimes < 10)
	{
		//BAD POTENTIALITIES
		if (action == 2) if (!bCanTeach) break;
		if (action == 3) if (!bCanLearn) break;
		
		//BAD TARGETS
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;
		if (!.IsVisible)   break;
		if (!.InRange(tgt)) break;

		//EARLY BREAK IF TEACH CAN NOT BE DONE, AND TEACH IS THE CURRENT ACTION
		if (action == 2) {
			if (tgt.inherentlevel >= level) break;
			if (.stamina < teach_stamina_cost) break;
		}

		//EARLY BREAK IF LEARNING CAN NOT BE DONE AND LEARN IS THE CURRENT ACTION
		if (action == 3) {
			if (tgt.experience <= .experience) break;
			if (.stamina < learn_stamina_cost) break;
		}

		if (action == 2)
		{	//TEACH
			.StartAnim(17, tgt.pos);
			Sleep(.TimeToActionMoment());
			
			if (tgt.IsAlive)
			if (tgt.inherentlevel < level)
			if (.stamina >= teach_stamina_cost)
			if (!tgt.InHolder)
			if (.CanSee(tgt))
			if (!.IsEnemy(tgt))
			{
				.SetVisible(true); .SetLastAttackTime();
				.SetStamina(.stamina - teach_stamina_cost);
				tgt.SetExperience(tgt.experience + k + (chance > rand(99)));
				CreateFeedback("Experience", tgt);
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
	if (.IsEnemyInSquadSight)
		action = 2;
	else if (!bSuccess || action == 3)
		action = 5 - action;
	for (i = 0; i < 2; i += 1) {
		if (action == 2 && !bCanTeach) action = 5;
		if (action == 5 && !bCanLearn) action = 2;
		if (action == 2)
			tgt = .FindUnitBelowILevel(level).AsUnit;
		else
			tgt = .FindUnitToLearn.AsUnit;
		if (tgt.IsValid) break;
		if (!bCanTeach || !bCanLearn) break;
		action = 5 - action;
	}
}
