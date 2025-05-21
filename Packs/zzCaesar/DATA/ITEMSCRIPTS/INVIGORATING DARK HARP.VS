//void, Obj owner

Unit this, u;
ObjList ol;
int i, allies_revitalized;

this = owner.AsUnit();

while (.IsValid) {
	while (GetUseCount() > 0) {
		Sleep(1000);
		SetUseCount(GetUseCount() - 1);
	}

	if (.stamina < .maxstamina)
		.HealStamina(4);
	if (.InHolder) {
		ol = .GetUnitsInSameHolder();
		ol.Remove(this);
	}
	else
		ol = ObjsInSight(this, "Unit").GetObjList();

	allies_revitalized = 0;

	//make 25 attempts to revitalize 8 random allies, then in order
	for (i = 0; ol.count > 0 && i < 25 && allies_revitalized < 8; i += 1) {
		u = ol[rand(ol.count)];
		if (u.IsValid)
			if (!u.IsDead())
				if (!.IsEnemy(u))
					if (u.stamina < u.maxstamina) {
						allies_revitalized += 1;
						u.HealStamina(4);
						if (!u.InHolder)
							CreateFeedback("StaminaBoostHarp", u);
						ol.Remove(u);//avoid revitalizing the same unit more than once
					}
	}
	for (i = 0; i < ol.count && allies_revitalized < 8; i += 1) {
		u = ol[i];
		if (u.IsValid)
			if (!u.IsDead())
				if (!.IsEnemy(u))
					if (u.stamina < u.maxstamina) {
						allies_revitalized += 1;
						u.HealStamina(4);
						if (!u.InHolder)
							CreateFeedback("StaminaBoostHarp", u);
					}
	}

	SetUseCount(10);
}