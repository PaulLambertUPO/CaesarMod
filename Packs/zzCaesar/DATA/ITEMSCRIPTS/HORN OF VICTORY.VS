//void, Obj owner

Unit this;

this = owner.AsUnit();

if (!.InHolder) {
	ObjList ol;
	Unit u;
	int i, enemies_damaged;

	ol = ObjsInSight(this, "Unit").GetObjList();

	//make 25 attempts to damage 15 enemies chosen randomly, then in order
	for (i = 0; ol.count > 0 && i < 25 && enemies_damaged < 15; i += 1) {
		u = ol[rand(ol.count)];
		if (u.IsValid)
			if (!u.IsDead())
				if (.IsEnemy(u)) {
					enemies_damaged += 1;
					u.Damage(75);
					CreateFeedback("Damage2", u);
					ol.Remove(u);//avoid damaging the same unit more than once
				}
	}
	for (i = 0; i < ol.count && enemies_damaged < 15; i += 1) {
		u = ol[i];
		if (u.IsValid)
			if (!u.IsDead())
				if (.IsEnemy(u)) {
					enemies_damaged += 1;
					u.Damage(75);
					CreateFeedback("Damage2", u);
				}
	}

	if (enemies_damaged > 0)
		ItemUsed(1);

	Sleep(1000);//cooldown
}
else
	UserNotification("item cannot use in holder", "", owner.posRH, owner.player);