//void, Obj this

Settlement set;
ObjList ol;
Obj o;
int i;

set = .AsBuilding().settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	o = ol[i];
	if (o.IsAlive)
		if (o.stamina < o.maxstamina)
			if (!.IsEnemy(o)) {
				o.SetStamina(o.maxstamina);
				CreateFeedback("StaminaBoost", o.AsUnit());
			}
}

.PlaySound("Data/Sound Entities/TownhallRefreshment.xml");