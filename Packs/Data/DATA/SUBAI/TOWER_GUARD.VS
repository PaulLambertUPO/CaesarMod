// void, Obj me

Tower this;
this = me.AsTower;

//pr("FireTower::Guard");

while (.IsValid)
{
	Unit target;
	if (.settlement.IsOutpost() && .settlement.IsIndependent)
	{
			Sleep(500);
			return;
	}
	target = .GetUITarget.AsUnit;
	if (target.IsAlive)
	if (.IsValidTarget(target))
	if (.CanAttack(target))
	{
		bool bAttacked = false;
		while (.Attack(target))
		{
			bAttacked = true;
			Sleep(100);
			if (!.IsValid) return;
			if (!target.IsAlive) break;
		}
		Sleep(500);
		if (bAttacked) continue;
	}
//	pr("Looking for best target");
	target = .BestTarget;
	if (!target.IsAlive) {
//		pr("Best target not found, sleeping for 1000");
		Sleep(1000); 
		continue;
	}
//	pr("Trying to attack enemy");
	while (.Attack(target)) {
//		pr("FireTower::Guard - attacking");
		Sleep(100);
		if (!.IsValid) return;
		if (!target.IsValid) break;
		if (!target.IsAlive) break;
	}
	Sleep(500);
}
