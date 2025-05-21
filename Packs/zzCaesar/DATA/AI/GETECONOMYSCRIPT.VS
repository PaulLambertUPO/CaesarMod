//int, Settlement set, int idPlayer

if (set.IsVillage)
	return ES_Village;
if (set.IsStronghold)
	return ES_Stronghold;
if (set.IsShipyard)
	return ES_Shipyard;
if (set.IsTTent) {
	if (set.food >= 100)
		return ES_OutpostSendGold;
	else if (set.gold >= 100)
		return ES_OutpostSendGold;
}
else if (set.IsOutpost) {
	int nRace;
	nRace = set.GetCentralBuilding().race;
	if (set.supplied.IsValid) {
		if (nRace == Gaul)
			return ES_OutpostSellFood;
		if (nRace == Germany)
			return ES_OutpostSellFood;
	}
	else if (set.gold >= 100)
		return ES_OutpostSendGold;
	else if (set.food >= 100)
		return ES_OutpostSendGold;
	if (nRace == Carthage)//note that the Greek outpost has Carthage as race value
		return ES_OutpostArmy;
}
return ES_NONE;