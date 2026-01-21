//void, Obj owner

Unit this, u;
ObjList ol;
int i, allies_revitalized;

this = owner.AsUnit();

if (.IsValid)
	while (1) {
		while (GetUseCount() > 0) {
			Sleep(1000);
			SetUseCount(GetUseCount() - 1);
		}

		if (.stamina < .maxstamina) {
			.HealStamina(4);
			if (!.InHolder)
				CreateFeedback("StaminaBoost", this);
		}

		allies_revitalized = 0;
		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else {
			.PlaySound("Data/Sound Entities/ItemUse_DarkChant.xml");
			ol = ObjsInSight(this, "Unit").GetObjList();
		}

		//make 25 attempts to revitalize 8 random allies, then in order
		for (i = 0; ol.count > 0 && i < 25 && allies_revitalized < 8; i += 1) {
			u = ol[rand(ol.count)];
			if (u.IsValid)
				if (u.IsAlive)
					if (u.stamina < u.maxstamina)
						if (!.IsEnemy(u)) {
							allies_revitalized += 1;
							u.HealStamina(4);
							if (!u.InHolder)
								CreateFeedback("StaminaBoost", u);
							ol.Remove(u);//avoid revitalizing the same unit more than once
						}
		}
		for (i = 0; i < ol.count && allies_revitalized < 8; i += 1) {
			u = ol[i];
			if (u.IsValid)
				if (u.IsAlive)
					if (u.stamina < u.maxstamina)
						if (!.IsEnemy(u)) {
							allies_revitalized += 1;
							u.HealStamina(4);
							if (!u.InHolder)
								CreateFeedback("StaminaBoost", u);
						}
		}

		SetUseCount(10);
	}