//void, Obj owner

ObjList ol;
Unit u, this;
int i, allies_healed;

this = owner.AsUnit();

if (.InHolder) {
	ol = .GetUnitsInSameHolder();
	ol.Remove(this);
}
else
	ol = ObjsInSight(this, "Unit").GetObjList();

if (.health < .maxhealth) {
	.Heal(.maxhealth);
	if (!.InHolder)
		CreateFeedback("Heal", this);
}

//make 25 attempts to heal 8 allies chosen randomly, then in order
for (i = 0; ol.count > 0 && i < 25 && allies_healed < 8; i += 1) {
	u = ol[rand(ol.count)];
	if (u.IsValid)
		if (!u.IsDead())
			if (!.IsEnemy(u))
				if (u.health < u.maxhealth) {
					allies_healed += 1;
					u.Heal(u.maxhealth);
					if (!u.InHolder)
						CreateFeedback("Heal", u);
					ol.Remove(u);//avoid healing the same unit more than once
				}
}
for (i = 0; i < ol.count && allies_healed < 8; i += 1) {
	u = ol[i];
	if (u.IsValid)
		if (!u.IsDead())
			if (!.IsEnemy(u))
				if (u.health < u.maxhealth) {
					allies_healed += 1;
					u.Heal(u.maxhealth);
					if (!u.InHolder)
						CreateFeedback("Heal", u);
				}
}

ItemUsed(1);