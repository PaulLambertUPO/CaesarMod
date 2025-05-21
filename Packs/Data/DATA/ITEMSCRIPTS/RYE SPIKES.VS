//void, Obj owner

ObjList ol;
Unit u, this;
int i, nFood, nGive;

this = owner.AsUnit();
if (!.IsValid()) return;

nFood = GetUseCount();
if (.food < .maxfood) {
	nGive = .maxfood - .food;
	if (nGive > nFood) nGive = nFood;
	nFood -= nGive;
	.SetFood(.food + nGive);
	if (nFood == 0) {
		ItemUsed(GetUseCount());
		return;
	}
}

if (.InHolder)
	ol = .GetUnitsInSameHolder();
else
        ol = ObjsInSight(owner, "Military").GetObjList(); //first try the militaries

for(i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	if (u.IsDead()) continue;
	if (.IsEnemy(u)) continue;
	if (u.food < u.maxfood) {
		nGive = u.maxfood - u.food;
		if (nGive > nFood) nGive = nFood;
		nFood -= nGive;
		u.SetFood(u.food + nGive);
		if (nFood == 0) {
			ItemUsed(GetUseCount());
			return;
		}
	}
}

if (!.InHolder)
{
//if some food is left - give it to the poor, I mean the civilians :)
	ol = ObjsInSight(owner, "Peaceful").GetObjList();
	for(i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsDead()) continue;
		if (owner.IsEnemy(u)) continue;
		if (u.food < u.maxfood) {
			nGive = u.maxfood - u.food;
			if (nGive > nFood) nGive = nFood;
			nFood -= nGive;
			u.SetFood(u.food + nGive);
			if (nFood == 0) {
				ItemUsed(GetUseCount());
				return;
			}
		}
	}
}

ItemUsed(GetUseCount()-nFood);
return;
