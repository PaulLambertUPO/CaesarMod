// void, str GroupName, str Target

// Guard AI Helper

Settlement set;
int AIPlayer;
ObjList ol;
Obj oTarget;
Unit u, uEnemy;
Query qryDef;
int i, j, n, nEnemies;
point pt;
int nMaxCatapults = 1;
bool bSieging, bToSiege;
rect rcMap;

set = GetSettlement(Target);
if (!set.IsValid)
	return;

qryDef = Group(GroupName);
ol = qryDef.GetObjList();
if (ol.count <= 0)
	return;
AIPlayer = ol[0].player;
rcMap = GetMapRect;

/// Outpost
if (set.IsOutpost)
{
	oTarget = set.GetCentralBuilding;
	
	// Find gather point
	while (1)
	{
		ObjList olAdvance;
		int nReached = 0;
		ol = qryDef.GetObjList();
		if (ol.count <= 0)
			return;
		for (j = 0; j < ol.count; j += 1)
		{
			u = ol[j].AsUnit;
			if (u.hero.IsValid) continue;
			if (u.DistTo(oTarget) > oTarget.sight * 3 / 2)
			{
				if (u.command != "advance")
					olAdvance.Add(u);
			} else {
				if (u.command != "capture" && u.command != "attack")
					u.SetCommand("capture", oTarget);
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

	ol = qryDef.GetObjList();
	if (set.UnitsCount == 0)
		bToSiege = false;
	else {
		Query ProtectiveArea, EnemyUnits;
		ProtectiveArea = ObjsInSight(set.GetCentralBuilding, "Unit");
		EnemyUnits = Intersect(ProtectiveArea, EnemyObjs(AIPlayer, "Unit"));
		nEnemies = set.UnitsCount + EnemyUnits.count;
		bToSiege = ol.count < 2 * nEnemies;
	}
	bSieging = false;
	while (1)
	{
		bool bCat = false;	
		ol = qryDef.GetObjList();
		if (ol.count <= 0)
			break;
		if (!oTarget.IsEnemy(ol[0]))
			break;
		/// siege logic
		if (set.UnitsCount == 0)
			bToSiege = false; /// siege when there are many enemies
		else
		{	/// calculate enemies
			Query ProtectiveArea, EnemyUnits;
			ProtectiveArea = ObjsInSight(set.GetCentralBuilding, "Unit");
			EnemyUnits = Intersect(ProtectiveArea, EnemyObjs(AIPlayer, "Unit"));
			nEnemies = set.UnitsCount + EnemyUnits.count;
			if (ol.count <= nEnemies)
				bToSiege = true; /// siege when there are many enemies
		}
		if (bSieging) if (ol.count > 4 * nEnemies)
			{ bSieging = false;	bToSiege = false; } /// capture when our army is too larger
		if (!bSieging) if (bToSiege)
		{	/// start sieging
			nMaxCatapults = ol.count / 15;
			if (nMaxCatapults <= 0)
				nMaxCatapults = 1;
			ol.Siege(oTarget, nMaxCatapults, 0);
			bSieging = true;
		}
		bToSiege = bSieging;
		for (j = 0; j < ol.count; j += 1)
		{
			u = ol[j].AsUnit;
			if (!u.IsValid)
				continue;
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
			if (!bSieging)
				if (u.DistTo(oTarget) < 500)
					if (u.command != "capture")
						u.SetCommand("capture", oTarget);
				else
					if (u.command != "advance")
						u.SetCommand("advance", oTarget.pos);
			else
			{
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
	/// stop catapults
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid) continue;
		if (u.GetHolderSett.IsValid)	{
			Catapult cat;	cat = u.GetHolderSett.GetCentralBuilding.AsCatapult;
			if (cat.IsValid) cat.SetCommand("stop");
		}
	}

	return;
}	/// end Outpost
	
/// Stronhold
if (ol.count <= 0)
	return;
oTarget = set.BestGate(ol[0].pos);

if (set.IsStronghold&&oTarget.IsValid())
{

// pr("Find gather point");
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
		{/// start sieging
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
			if (u.command != "idle")
			if (u.command != "stand_position")
			if (u.command != "capture")
				continue;
			if (rand(30) == 0)
			{
				pt.Set(0, oTarget.radius + rand(60));
				pt.Rot(rand(360));
				pt = pt + oTarget.pos;
				pt.IntoRect(rcMap);
				if (u.command != "advance")
					u.SetCommand("advance", pt);
			} else
				if (u.command != "capture")
					u.SetCommand("capture", oTarget);
		}
		Sleep(2000);
	}
	return;
}	/// end Townhall

oTarget = set.GetCentralBuilding;

// Find gather point
while (1)
{
	bool bReached = true;
	ol = qryDef.GetObjList();

	if (ol.count == 0)
		break;
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid) continue;
		if (u.DistTo(oTarget) > 4 * oTarget.sight)
		{
			if (u.command != "advance")
				u.SetCommand("advance", oTarget.pos);
			bReached = false;
		} else
			u.KillCommand();
	}
	if (bReached)
		break;
	Sleep(10000);
}
// pr("Army's gathered");
if (ol.count <= 0)
	return;

/*for (j = 0; j < ol.count; j += 1)
{
	u = ol[j].AsUnit;
	if (!u.IsValid) continue;
	if (u.hero.IsValid) continue;
	pt = oTarget.pos - u.pos;
	pt.Set(-pt.x, -pt.y);
	pt = oTarget.pos - pt;
	pt.IntoRect(rcMap);
	u.SetCommand("advance", oTarget.pos - pt);
}*/

while (1)
{
	Unit uEnemy;
	Sleep(6000);
	ol = qryDef.GetObjList();
	if (ol.count <= 0)
		break;
	if (!oTarget.IsEnemy(ol[0]))
		break;
	for (j = 0; j < ol.count; j += 1)
	{
		u = ol[j].AsUnit;
		if (!u.IsValid) continue;
		if (u.hero.IsValid) continue;
		if (rand(10) == 0)
			uEnemy = u.BestTargetInSquadSight.AsUnit;
		pt = oTarget.pos - u.pos;
		if (rand(2)) 
			pt.Set(-pt.x, pt.y);
		if (rand(2)) 
			pt.Set(pt.x, -pt.y);
		pt = pt + oTarget.pos;
		pt.IntoRect(rcMap);
		if (uEnemy.IsAlive) {
			if (u.command != "advance") {
				u.AddCommand(true, "advance", uEnemy.pos);
				u.KillCommand();
			}
		}
		else if (rand(20) == 0) {
			if (u.command != "advance") {
				u.AddCommand(true, "advance", pt);
				u.KillCommand();
			}
		}
		else if (u.command != "capture") {
			u.AddCommand(true, "capture", oTarget);
			u.KillCommand();
		}
	}
}
