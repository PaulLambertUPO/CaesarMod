// void, Settlement set

/// writes in the environment the nearst village to supply from it

int idPlayer, nRace;
Building cb, vil, vilOther, bDummy;
ObjList olVil;
int i, nBest;

idPlayer = set.player;
cb = set.GetCentralBuilding;
nRace = cb.race;

nBest = 100000000;
olVil = GetSettlements("BaseVillage", idPlayer);
for (i = 0; i < olVil.count; i += 1)
{
	int n, nWeight;
	Building bldVil;
	bldVil = olVil[i].AsBuilding;
	n = EnvReadInt(bldVil.settlement, "SupplyStronghold");
	if (n == 0) n = 100000;
	nWeight = cb.DistTo(bldVil) * 10000 / n;
	if (nWeight < nBest)
	{
		Building b2; b2 = EnvReadObj(bldVil.settlement, "SupplyOutpost").AsBuilding;
		if (b2.IsValid) if (b2 != cb) if (b2.DistTo(bldVil) <= nWeight)
			continue;
		nBest = nWeight;
		vil = bldVil;
		vilOther = b2;
	}
}
if (vilOther.IsValid)
	EnvWriteObj(vilOther.settlement, "SupplyOutpost", bDummy);
EnvWriteObj(set, "SuppledVillage", vil);
if (vil.IsValid)
	EnvWriteObj(vil.settlement, "SupplyOutpost", cb);



Sleep(5000);
