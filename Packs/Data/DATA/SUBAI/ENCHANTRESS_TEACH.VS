// void, Obj This, Obj target

Druid this;
Unit tgt;
int level, level1, level2;
int teach_stamina_cost;
bool bSuccess;
bool bSleep = true;
int chance, k;

this = This.AsDruid();
if (!.IsAlive)
	return;
if (!.HasSpecial(teaching))
	return;

tgt = target.AsUnit();
if (tgt == this)
	return;
if (!tgt.IsAlive)
	return;
if (target.AsShip.IsValid)
	return;

teach_stamina_cost = GetCmdStaminaCost("teach");
chance = GetConst("EnchantressTeachPercent");
if (IsResearched(.player, "Code of Valor"))
	chance += .level * GetConst("EnchantressTeachIncrease");
k = chance / 100;
chance = chance % 100;

//TO WHAT LEVEL SHOULD WE TRAIN UNITS?
level1 = GetConst("TeachingLevel1");
level2 = GetConst("TeachingLevel2");

level = level1;
if (EnvReadString(.player, "Ancestral Knowledge") == "researched")
	level = level2;

while (.IsAlive && tgt.IsAlive)
{
	while (1)
	{
		bSuccess = false;

		if (!.IsAlive)     break;
		if (!tgt.IsAlive)  break;
		if (.IsEnemy(tgt)) break;
		if (tgt.InHolder)  break;
		if (!.CanSee(tgt)) break;
		if (tgt == this)   break;

		if (level < level2) if (EnvReadString(.player, "Ancestral Knowledge") == "researched")
			level = level2;
		if (tgt.inherentlevel >= level) break;

		bSleep = false;
		if (!.InRange(tgt))	{
			.GotoAttack(tgt, 5000, false, 2500);
			continue;
		}
		if (.stamina < teach_stamina_cost) {
			Sleep(200);
			continue;
		}
		.SetLastAttackTime();
		if (!.IsVisible)
			.SetVisible(true);
		
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
	}
	if (!bSuccess)
		Sleep(1103);
	tgt = .FindUnitBelowILevel(level);
}

if (bSleep)
	Sleep(17); // otherwise can cycle: Advance->Teach->Advance->Teach...
