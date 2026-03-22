//void, Obj this

Settlement set;
ObjList ol;
Obj o;
int i, health_given, health_to_distribute = 2000;

set = .AsBuilding().settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	o = ol[i];
	if (o.IsAlive)
		if (o.health < o.maxhealth)
			if (!.IsEnemy(o)) {
				health_given = MIN(health_to_distribute, o.maxhealth - o.health);
				health_to_distribute -= health_given;
				o.Heal(health_given);
				CreateFeedback("Heal", o.AsUnit());
				if (health_to_distribute <= 0)
					break;
			}
}