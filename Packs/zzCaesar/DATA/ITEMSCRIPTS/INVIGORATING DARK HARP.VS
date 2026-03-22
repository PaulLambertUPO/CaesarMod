//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	ObjList ol;
	Obj o;
	int i, allies_revitalized;

	while (1) {
		while (GetUseCount() > 0) {
			Sleep(1000);
			SetUseCount(GetUseCount() - 1);
		}

		if (.stamina < .maxstamina) {
			.HealStamina(4);
			CreateFeedback("StaminaBoost", this);
		}

		if (.InHolder) {
			ol = .GetUnitsInSameHolder();
			ol.Remove(this);
		}
		else {
			.PlaySound("Data/Sound Entities/ItemUse_DarkChant.xml");
			ol = ObjsInSight(this, "Unit").GetObjList();
		}

		allies_revitalized = 0;

		while (ol.count > 0) {
			o = ol[rand(ol.count)];
			if (o.IsAlive)
				if (o.stamina < o.maxstamina)
					if (!.IsEnemy(o)) {
						o.HealStamina(4);
						CreateFeedback("StaminaBoost", o.AsUnit());
						allies_revitalized += 1;
						if (allies_revitalized >= 8)
							break;
					}
			ol.Remove(o);
		}

		SetUseCount(10);
	}
}