// void, Obj This, Obj target
Hero this;
point pt;
int i;
this = This.AsHero;

if (!target.IsValid)
	return;

if (.InHolder || .PathTo(target, .FormRadius, 0) > .sight) {
	.FormSetupAndMoveTo(target, 0, 0, true);
	while (1)
	{
		if (!.HasPath) break;
		if (!target.IsAlive) break;
		if (.DistTo(target) <= .sight * 2 / 3) break;
		.FormKeepMoving(1500);	
	}
}

while (!.IsArmyOutside)
	.FormKeepMoving(500);

//.pr("hero::attack: target locked!!!");

if (!target.IsValid)
	return;
if (target.AsBuilding)
{
	for (i = 0; i < .army.count; i += 1)
		if (.army[i].IsValidTarget(target))
			.army[i].SetCommand("attack", target);
		else
			.army[i].SetCommand("idle");
	if (!.IsValidTarget(target))
		return;
} else {
	// attack the target with all ranged units
	for (i = 0; i < .army.count; i += 1)
		if (.army[i].IsRanged())
			.army[i].SetCommand("attack", target);
		else
			.army[i].SetCommand("engage");
}
while (target.IsAlive)
{
	if (!.IsEnemy(target))
		return;
	//.pr("hero::attack: going to enemy");
	if (.GotoAttack(target, 5000, true, 2500))
	{
		//.pr("hero::attack: fighting");
		while (target.IsAlive)
		{
			if (!.Attack(target)) break;
			Sleep(19);
		}
	}

	Sleep(17);
}

.AddCommand(true, "engage");
