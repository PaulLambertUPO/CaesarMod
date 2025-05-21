//void, Settlement set

int Greece, AIPlayer, min_pop, pop_group, nSleepES, nRectLongestSide, nBestDist;
bool bUseForts;
str cmd;
Building hall;
Settlement stronghold;
point ptDummy;
Obj objDummy;

Greece = ImperialRome;
AIPlayer = set.player;
min_pop = GetConst("MinPopulation");
pop_group = GetConst("PopGroup");
nSleepES = AIVar(AIPlayer, AIV_Sleep_ES);
if (AIVar(AIPlayer, AIV_VillageDrain) != 0) {
	rect rc;
	rc = GetMapRect();
	nRectLongestSide = MAX(rc.width, rc.height);
}
bUseForts = AIVar(AIPlayer, AIV_UseForts) != 0;
hall = set.GetCentralBuilding();
if (hall.race == Greece)
	cmd = "trainpeasanth";
else
	cmd = "trainpeasant" + hall.raceStrPrefLow;

while (set.player == AIPlayer) {
	stronghold = set.BestToSupply();//it returns the nearest owned stronghold
	if (stronghold.IsValid) {
		int dist;
		dist = hall.DistTo(stronghold.GetCentralBuilding());
		if (dist != nBestDist) {
			nBestDist = dist;
			EnvWriteInt(set, "SupplyStronghold", dist);
		}
		if (hall.command == "idle") {
			set.StartSupplyFood(stronghold);

			if (set.population - pop_group >= min_pop) {
				bool bCanDrain = false;

				if (set.population >= set.max_population)
					bCanDrain = true;
				else if (nRectLongestSide > 0)//see original script for reference (it considers stronghold/village food/population weight)
					if (MIN(100, stronghold.food * 100 / MAX(300, MilUnits(AIPlayer) * 20 / Strongholds(AIPlayer))) - stronghold.population * 100 / stronghold.max_population
							>= 60 - dist * 100 / nRectLongestSide - set.population * 100 / set.max_population / 2)
						bCanDrain = true;

				if (bCanDrain) {
					if (bUseForts) {
						Building outpost;
						outpost = EnvReadObj(set, "SupplyOutpost").AsBuilding();
						if (outpost.IsValid) {
							bool supplyOutpost = false;
							if (outpost.player == AIPlayer)
								if (outpost.race == Carthage)//note that the Greek outpost has Carthage as race value
									if (hall == EnvReadObj(outpost.settlement, "SuppledVillage").AsBuilding())
										supplyOutpost = true;
							if (supplyOutpost) {
								ObjList ol;
								int i, peasants;
								ol = outpost.settlement.Units;
								for (i = 0; i < ol.count; i += 1)
									if (ol[i].IsHeirOf("Peasant")) {
										peasants += 1;
										if (peasants >= 5)
											break;
									}
								if (peasants < 5)
									set.StartSupplyFood(outpost.settlement);
							}
							else {
								Building bDummy;
								EnvWriteObj(set, "SupplyOutpost", bDummy);
							}
						}
					}
					hall.ExecCmd(cmd, ptDummy, objDummy, false);
				}
			}
		}
	}
	else
		set.StopSupply();

	Sleep(nSleepES);
}