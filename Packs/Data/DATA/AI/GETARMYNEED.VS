// int, GAIKA g, int idPlayer, bool bMin, int own, int ally, int enemy

bool bCap = true;
int nEval = 0;
int own1, ally1, enemy1;
int vikings;
bool bEnemySet = false;
Settlement Set;

Set = g.settlement;

if (Set.IsValid)
if (Set.IsEnemy(idPlayer))
	bEnemySet = true;

if (!g.Explored(idPlayer))
if (!Set.IsTeutonTent || GetTime > 600000)
	return 1;

if (Set.IsIndependent)
if (!Set.IsIndependentGuarded)
if (!Set.IsTeutonTent)
if (!Set.IsStronghold)
	return 1;

if (!g.Revealed(idPlayer))
if (!Set.IsStronghold)
if (GetTime - g.LastSeen(idPlayer) >= 600000)
	enemy = 1; // expect only few enemies if non-stronghold GIAKA not visited for 10 min

// Add enemies from adjacent revealed GAIKA
if (enemy > 0) {
	g.EvalNeighbors(AI_STAYING, idPlayer, own1, ally1, enemy1, true); // 'true' == revealed GAIKA only
	if (enemy1 > own1)
		enemy += (enemy1 - own1) * 2 / 3;
}
if (Set.IsValid)
	if (Set.IsOwn(idPlayer))
	{ // own settlement
		if (enemy == 0)
		{ // protect unattacked settlements
			if (Set.IsOutpost)
			if (Set.supplied.IsValid) // trading outpost, some protection
			if (Set.gold > 1000 || Set.food > 500)
				if (bMin)
					nEval = 6000;
				else
					nEval = 10000;
			return nEval; 
		}
		if (enemy > 500)
			bCap = false; // no minimum when defending our settlements
	}
	else
		if (!Set.IsStronghold && !Set.IsVillage && !Set.IsOutpost && !Set.IsShipyard)
		{
			if (enemy == 0)
				return 0;
		}
		else
			if (Set.IsIndependent)
			{
				if (Set.IsStronghold)
					return 1500;
				if (enemy == 0)
					return 1;
			}
			else
				if (Set.IsEnemy(idPlayer))
				{	// enemy settlement
					nEval += 1;
					if (Set.IsStronghold)
					{ // strongholds are tough :)
						if (bMin)
							nEval += 5000;
						else
							nEval += 15000;
						enemy += enemy1 / 2;
						vikings = EvalGroup("Player" + idPlayer + "BVikingLord");
					}
					else
						if (Set.IsVillage)
						{
							Settlement s; s = NearestStronghold(Set.GetCentralBuilding.pos, idPlayer);
							if (s.IsValid)
							if (s.food < 100)
								bCap = false; // no minimum for enemy villages if starving
						}
				}

// enemies
if (bMin)
{
	int min;
	if (!bCap) min = 0;
	else if (GetTime < 600000) min = 2000;
	else if (GetTime < 120000) min = 3000;
	else if (GetTime < 180000) min = 5000;
	else min = 6000;

	if (Set.IsStronghold)
	if (Set.IsEnemy(idPlayer))
	if (!bCap)
	if (min < vikings + 3000)
		min = vikings + 3000; // Do not attack strongholds with viking lords only

	if (GetTime < 900000) // Be more careful at game start
		nEval += enemy * 15 / 10;
	else
		nEval += enemy * 11 / 10;
	if (nEval > 0 || bEnemySet)
	if (nEval < min)
		nEval = min;
}
else
{
	int min;
	if (!bCap) min = 0;
	else if (GetTime < 600000) min = 4000;
	else if (GetTime < 120000) min = 6000;
	else if (GetTime < 180000) min = 10000;
	else min = 12000;

	if (Set.IsStronghold)
	if (Set.IsEnemy(idPlayer))
	if (!bCap)
	if (min < vikings + 3000)
		min = vikings + 6000; // Do not attack strongholds with viking lords only

	nEval += enemy * 4;
	if (nEval > 0 || bEnemySet)
	if (nEval < min)
		nEval = min;
}

/*
if (!g.Revealed(idPlayer))
if (nEval == 0)
if (GetTime - g.LastSeen(idPlayer) >= 300000)
	nEval = 1; // wish to check out GAIKA's not visited for 5 min
*/

return nEval;
