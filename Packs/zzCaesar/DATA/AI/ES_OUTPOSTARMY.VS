//void, Settlement set

//returned by GetEconomyScript, this script writes in the recruitment outpost environment which village is better to supply from (it works in pair with ES_Village)

Building hall, bestVillage, otherOutpost, bldVil, bldVilOutpost, invalid;
ObjList olVillages;
int aiPlayer, hallLsa, nDistWeight, i, nBest = 100000000;

aiPlayer = set.player;
hall = set.GetCentralBuilding();
hallLsa = hall.LSA;

while (set.player == aiPlayer) {
	olVillages = GetSettlements("BaseVillage", aiPlayer);

	for (i = 0; i < olVillages.count; i += 1) {
		bldVil = olVillages[i].AsBuilding();
		if (bldVil.LSA == hallLsa) {
			nDistWeight = EnvReadInt(bldVil.settlement, "ES_SuppliedStronghold");
			if (nDistWeight <= 0)
				nDistWeight = 100000;
			nDistWeight = hall.DistTo(bldVil) * 10000 / nDistWeight;
			if (nDistWeight < nBest) {
				bldVilOutpost = EnvReadObj(bldVil.settlement, "ES_SuppliedOutpost").AsBuilding();
				if (bldVilOutpost.IsValid)
					if (bldVilOutpost != hall)
						if (bldVilOutpost.DistTo(bldVil) <= nDistWeight)
							continue;
				nBest = nDistWeight;
				bestVillage = bldVil;
				otherOutpost = bldVilOutpost;
			}
		}
	}

	EnvWriteObj(set, "ES_SupplierVillage", bestVillage);
	if (otherOutpost.IsValid)
		if (otherOutpost != hall)
			EnvWriteObj(otherOutpost.settlement, "ES_SupplierVillage", invalid);
	if (bestVillage.IsValid)
		EnvWriteObj(bestVillage.settlement, "ES_SuppliedOutpost", hall);

	Sleep(15000);
}