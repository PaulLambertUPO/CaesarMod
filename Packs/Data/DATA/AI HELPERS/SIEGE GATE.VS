// void, str GroupName, str Target

// Siege Gate AI Helper

Settlement set;
ObjList ol;
Obj oTarget;
Unit u, uEnemy;
Query qryDef;
int i, j, n;
point pt;
int nMaxCatapults = 1;
bool bSieging;
rect rcMap;

qryDef = Group(GroupName);
ol = qryDef.GetObjList();
if (ol.count == 0)
	return;
oTarget = GetNamedObj(Target);
if (!oTarget.AsGate.IsValid)
	return;
set = oTarget.AsGate.settlement;
rcMap = GetMapRect;

// Find gather point
while (1)
{
	ObjList olAdvance;
	int nReached = 0;
	ol = qryDef.GetObjList();
	if (ol.count == 0)
		return;
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid) continue;
		if (GetGAIKA(u) != set.GetGaika || u.DistTo(oTarget) > 1000) {
			if (u.command != "advance")
				olAdvance.Add(u);
		} else {
			u.KillCommand();
			nReached += 1;
			if (u.AsHero.IsValid)
				nReached += u.AsHero.army.count();
		}
	}
	if (olAdvance.count > 0)
		olAdvance.ExecCmd("advance", oTarget.pos, u, false);
	if (nReached >= ol.count * 2 / 3)
		break;
	Sleep(2000);
}
// pr("Army's gathered");

bSieging = false;
while (!oTarget.AsGate.IsBroken)
{
	bool bCat = false;
	ol = qryDef.GetObjList();
	if (ol.count <= 0)
		break;
	if (!oTarget.IsEnemy(ol[0]))
		break;
	/// siege logic
	if (!bSieging)
	{	/// start sieging
		nMaxCatapults = ol.count / 15;
		if (nMaxCatapults <= 0)
			nMaxCatapults = 1;
		ol.Siege(oTarget, nMaxCatapults, 0);
		bSieging = true;
	}
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid)
			 continue;
		if (u.InHolder)	{
			bCat = true;
			if (bSieging)
				continue;
			u.SetCommand("advance", oTarget.pos);
		}
		if (u.command == "build_catapult")
			bCat = true;
		if (u.command == "engage")
			uEnemy = u.BestTargetInSquadSight.AsUnit;
		if (u.command != "idle" && u.command != "attack" && u.command != "move" && u.command != "advance")
			continue;
		if (uEnemy.IsAlive)	if (rand(3) == 0)
			{ u.SetCommand("advance", uEnemy.pos); continue; }
		if (u.command != "move")
		{	/// let the siege to place the units
			pt = u.pos - oTarget.pos;
			n = pt.Len + 1;
			if (n < 900 || n > 1000) {
				pt = pt * (900 + rand(100)) / n;
				pt = pt + oTarget.pos;
				pt.IntoRect(rcMap);
				u.SetCommand("advance", pt);
			}
		}
	}
	if (bSieging && !bCat)
		bSieging = false;	
	Sleep(2000);
}

ol = qryDef.GetObjList();
if (ol.count <= 0)
	return;
oTarget = set.GetCentralBuilding;
for (j = 0; j < ol.count; j += 1)
{
	u = ol[j].AsUnit;
	if (!u.IsValid) continue;
	if (u.hero.IsValid) continue;
	if (u.GetHolderSett.IsValid)	{
		Catapult cat;	cat = u.GetHolderSett.GetCentralBuilding.AsCatapult;
		if (cat.IsValid) cat.SetCommand("stop");
	}
	pt.Set(0, oTarget.radius + rand(60));
	pt.Rot(rand(360));
	pt = pt + oTarget.pos;
	pt.IntoRect(rcMap);
	u.SetCommand("advance", pt);
}
while (1)
{
	ol = qryDef.GetObjList();
	if (ol.count <= 0)
		return;
	if (!oTarget.IsEnemy(ol[0]))
		break;
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid) continue;
		if (u.command != "idle" && u.command != "capture")
			continue;
		if (rand(30) == 0)
		{
			pt.Set(0, oTarget.radius + rand(60));
			pt.Rot(rand(360));
			pt = pt + oTarget.pos;
			pt.IntoRect(rcMap);
			u.SetCommand("advance", pt);
		} else
			u.SetCommand("capture", oTarget);
	}
	Sleep(2000);
}
