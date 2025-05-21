//void, Obj owner

Unit this;

this = owner.AsUnit();

if (!.InHolder) {
	ObjList ol;
	Unit u;
	int i, enemies_killed;

	ol = ObjsInSight(this, "Unit").GetObjList();

	//make 25 attempts to kill 4 enemies chosen randomly, then in order
	for (i = 0; ol.count > 0 && i < 25 && enemies_killed < 4; i += 1) {
		u = ol[rand(ol.count)];
		if (u.IsValid)
			if (!u.IsDead())
				if (.IsEnemy(u))
					if (!u.AsHero().IsValid) {
						enemies_killed += 1;
						if (!u.InHolder)//units in sight are automatically not in holder, but they might enter in a building during the effect time
							CreateFeedback("Lightning2", u);
						Sleep(500);
						u.Damage(u.health);
						ol.Remove(u);//avoid killing the same unit more than once
					}
	}
	for (i = 0; i < ol.count && enemies_killed < 4; i += 1) {
		u = ol[i];
		if (u.IsValid)
			if (!u.IsDead())
				if (.IsEnemy(u))
					if (!u.AsHero().IsValid) {
						enemies_killed += 1;
						if (!u.InHolder)//units in sight are automatically not in holder, but they might enter in a building during the effect time
							CreateFeedback("Lightning2", u);
						Sleep(500);
						u.Damage(u.health);
					}
	}

	if (enemies_killed > 0)
		ItemUsed(1);

	Sleep(3000);//cooldown
}
else
	UserNotification("item cannot use in holder", "", owner.posRH, owner.player);