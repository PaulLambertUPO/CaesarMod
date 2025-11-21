//void, Settlement set

Settlement stronghold;

stronghold = set.BestToSupply;//it returns the nearest owned stronghold

if (stronghold.IsValid) {//it should always be valid thanks to "ESH_GoldTrade.vs" checks
	int aiPlayer, min_resource, i;
	Building hall;
	Wagon mule;

	aiPlayer = set.player;
	min_resource = GetConst("MinResQtyToTransport");
	hall = set.GetCentralBuilding();

	EnvWriteInt(aiPlayer, "GoldTradeStartInProgress", 1);

	//step 1: get gold from the nearest stronghold and check if mules are attacked
	{
		ObjList olMules;
		Building strongholdHall;
		int l, muleGold;
		bool bAttacked;

		strongholdHall = stronghold.GetCentralBuilding();
		l = set.loyalty;

		while (set.gold < 2000) {
			if (stronghold.player == aiPlayer)
				if (set.player == aiPlayer) {
					set.StopSupply();

					muleGold = 0;
					bAttacked = false;

					olMules = Group("ES_OutpostSellGoldMulesAI" + aiPlayer).GetObjList();
					for (i = 0; i < olMules.count; i += 1) {
						mule = olMules[i].AsWagon();
						if (mule.IsValid) {
							muleGold += mule.amount;
							if (!bAttacked)
								if (mule.health < mule.maxhealth * 2 / 3)
									bAttacked = true;
						}
					}

					if (set.loyalty < l)
						if (set.loyalty < 50) {
							while (set.gold >= min_resource) {
								if (set.player != aiPlayer)
									break;
								mule = set.CreateMuleGold(250);
								if (mule.IsValid) {
									mule.SetCommand("unload", strongholdHall);
									mule.AddToGroup("ES_OutpostSellGoldMulesAI" + aiPlayer);
								}
							}
							Group("ES_OutpostSellGoldMulesAI" + aiPlayer).SetCommand("unload", strongholdHall);
							if (!bAttacked)
								bAttacked = true;
						}

					l = set.loyalty;

					if (bAttacked)
						Sleep(18000);
					else {
						if (muleGold + set.gold < 2000)
							if (stronghold.gold >= 250) {
								mule = stronghold.CreateMuleGold(250);
								if (mule.IsValid) {
									mule.SetCommand("unload", hall);
									mule.AddToGroup("ES_OutpostSellGoldMulesAI" + aiPlayer);
								}
							}
						Group("ES_OutpostSellGoldMulesAI" + aiPlayer).SetCommand("unload", hall);
					}

					Sleep(2000);
					continue;
				}
				else
					Group("ES_OutpostSellGoldMulesAI" + aiPlayer).SetCommand("unload", strongholdHall);
			Group("ES_OutpostSellGoldMulesAI" + aiPlayer).RemoveFromAllGroups();
			EnvWriteInt(aiPlayer, "GoldTradeStartInProgress", 0);
			return;
		}
	}

	//step 2: manage group and environment
	Group("ES_OutpostSellGoldMulesAI" + aiPlayer).RemoveFromAllGroups();
	EnvWriteInt(aiPlayer, "GoldTradeStartInProgress", 0);
	EnvWriteInt(aiPlayer, "GoldTradeOutposts", EnvReadInt(aiPlayer, "GoldTradeOutposts") + 1);

	//step 3: Selling phase - check if the outpost is under attack
	i = set.loyalty;
	while (set.player == aiPlayer) {
		if (stronghold.player == aiPlayer) {
			if (!(set.supplied == stronghold))//the != operator does not exist for settlements
				set.StartSupplyFood(stronghold);
			if (set.loyalty < i)
				if (set.loyalty < 50) {
					set.StopSupply();
					break;
				}
			i = set.loyalty;
		}
		else {
			set.StopSupply();
			stronghold = NearestStronghold(hall.pos, aiPlayer, AI_ALLY);
			break;
		}
		Sleep(2000);
	}
	if (stronghold.IsValid) {
		hall = stronghold.GetCentralBuilding();
		while (set.gold >= min_resource) {
			if (set.player != aiPlayer)
				break;
			mule = set.CreateMuleGold(250);
			if (mule.IsValid)
				mule.SetCommand("unload", hall);
			Sleep(250);
		}
	}
	EnvWriteInt(aiPlayer, "GoldTradeOutposts", EnvReadInt(aiPlayer, "GoldTradeOutposts") - 1);
}