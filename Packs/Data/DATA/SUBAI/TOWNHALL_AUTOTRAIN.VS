//void, Obj This

point ptExit;
Building this;
ObjList lTraining;
int nSleep = 2000;
//bool bAIPlayer;
int AIPlayer;
int nLevel;
int nMaxDistance;
bool b, bMage, bMil;
bool bHeal, bTrained, bTraining, bToLearn;
int nMaxTraining = 30;
IntArray pCanLearn; /// mages for every race
int i;
int teach_level1, teach_level2;

this = This.AsBuilding;
AIPlayer = .player;

Sleep(rand(nSleep) + 500);

teach_level1 = GetConst("TeachingLevel1");
teach_level2 = GetConst("TeachingLevel2");

ptExit.Set(0,0);
ptExit.SetLen(.radius + 100);
nMaxDistance = .radius + 300;
//ptExit.SetLen(.radius + 64 + rand(64));
//ptExit.Rot(rand(360));
ptExit = ptExit + .pos;

pCanLearn[ImperialRome] = 1;
pCanLearn[RepublicanRome] = 1;
pCanLearn[Gaul] = 1;
pCanLearn[Iberia] = 1;
pCanLearn[Carthage] = 1;
pCanLearn[Britain] = 1;
pCanLearn[Egypt] = 1;
pCanLearn[Germany] = 1;

while (AIPlayer == .player)
{
	if (nSleep > 0)
		Sleep(nSleep);
	nSleep = 8 * 1000;

	//bAIPlayer = IsAIPlayer(.player);

	if (EnvReadString(.settlement, "autotrain") == "on")
	{
		Unit u, uLearnFrom;
		ObjList olInside, olOutside;
		int nMaxLearnLevel = 0;
		int nTraining = 0;
		bool bRitualChamber = false;

		if (lTraining.count + .settlement.Units.count <= 0)
			continue;

		pCanLearn[Gaul] = (EnvReadString(.player, "Ritual Chamber") == "researched");
		pCanLearn[Britain] = (EnvReadString(.player, "Ritual Chamber") == "researched");
		pCanLearn[Germany] = (EnvReadString(.player, "Ritual Chamber") == "researched");

		/// Gauls, Britains and Germany can learn only when "Ritual Chamber" is researched

		/// LIST UNITS IN THE HOLDER
		for (i = 0; i < .settlement.Units.count; i += 1)
		{
			u = .settlement.Units[i].AsUnit;
			if (u.IsAlive) if (u.player == .player)	if (u.IsHeirOf("Military") || u.IsHeirOf("BaseMage"))
			{
				if (!u.GetFlags(UNITFLAG_NOAI))
					olInside.Add(u);
				if (u.GetCommanded)
					u.SetCommanded(false); /// clear user commanded flag
				if (u.AsHero.IsValid)
				{
					int j;
					for (j = 0; j < u.AsHero.army.count; j += 1)
					{
						Unit u2;
						u2 = u.AsHero.army[j].AsUnit;
						if (u2.IsAlive) if (u2.IsHeirOf("Military") || u2.IsHeirOf("BaseMage"))
							if (!u2.GetFlags(UNITFLAG_NOAI)) if (.settlement == u2.GetHolderSett())
						{
							olInside.Add(u2);
							if (u2.GetCommanded)
								u2.SetCommanded(false); /// clear user commanded flag
						}
					}
				}
			}
			Sleep(1);	nSleep = nSleep - 1;
		}
		///--------- LIST OUTSIDE UNITS
		lTraining.RemoveList(olInside);
		lTraining.ClearDead;

		if (lTraining.count + olInside.count <= 0)
			continue;

		for (i = 0; i < lTraining.count; i += 1)
		{
			Sleep(1);	nSleep = nSleep - 1;
			u = lTraining[i].AsUnit;
			if (u.GetCommanded)
				continue;
			if (u.hero.IsValid())	if (u.hero.GetCommanded)
				continue;
			olOutside.Add(u);
		}

		if (olInside.count + olOutside.count > 0)
		{
			int nMaxLevelTraining, nMaxLevelTrained;
			int nToHeal, nToLearn, nInHolder, nMaxHealInHolder;
			int nToBeTrained, nCount, nMaxHealOutside;

			ObjList ol, lNewTraining;
			ObjList lHealers, lTrainers; /// units in these lists could exist also in one of the lists below
			ObjList lToHealIn, lToHealOut, lToBeTrained, lToTrain, lToLearn; /// unit could be only in one of these lists

			/// LIST THE HEALERS AND TRAINERS
			for (i = 0; i < olOutside.count; i += 1)
			{
				u = olOutside[i].AsUnit;
				nLevel = u.inherentlevel;
				b = nLevel > nMaxLearnLevel;
				if (u.IsHeirOf("BaseMage")) {
					if (u.HasSpecial(healing))
						lHealers.Add(u);
					else
						if (u.HasSpecial(teaching))
							lTrainers.Add(u);
					if (nLevel >= nMaxLearnLevel) b = true;
				}
				if (!b) if (nLevel == nMaxLearnLevel)	if (!u.AsHero.IsValid)
					if (uLearnFrom.AsHero.IsValid) b = true;
					else if (uLearnFrom.health < u.health) b = true;
				if (b) { uLearnFrom = u; nMaxLearnLevel = nLevel; }
				Sleep(1);	nSleep = nSleep - 1;
			}
			for (i = 0; i < olInside.count; i += 1)
			{
				Sleep(1);	nSleep = nSleep - 1;
				u = olInside[i].AsUnit;
				if (!u.IsValid)
					continue;
				nLevel = u.inherentlevel;
				b = nLevel > nMaxLearnLevel;
				if (u.IsHeirOf("BaseMage"))	{
					if (u.HasSpecial(healing))
						lHealers.Add(u);
					else
						if (u.HasSpecial(teaching))
							lTrainers.Add(u);
					if (nLevel >= nMaxLearnLevel) b = true;
				}
				if (!b) if (nLevel == nMaxLearnLevel)	if (!u.AsHero.IsValid)
					if (uLearnFrom.AsHero.IsValid) b = true;
					else if (uLearnFrom.health < u.health) b = true;
				if (b) { uLearnFrom = u; nMaxLearnLevel = nLevel; }
			}

			/// SPECIFY THE MAXIMUM TRAIN LEVELS
			nMaxLevelTraining = EnvReadInt(.player, "maxtrainlevel");
			nMaxLevelTrained = 0;
			if (lTrainers.count > 0)
			{
				nMaxLevelTrained = teach_level1;
				if (IsResearched(.player, "Ancestral Knowledge"))
					nMaxLevelTrained = teach_level2;
			}

			/// SPECIFY UNITS FOR TRAIN AND HEAL
			nToBeTrained = 0; /// the number of all units that could be trained
			nToHeal = 0;			/// the number of all units that need healing
			nToLearn = 0;
			for (i = 0; i < olOutside.count; i += 1)
			{
				Sleep(1);	nSleep = nSleep - 1;
				u = olOutside[i].AsUnit;
				if (u.GetCommanded) continue;
				if (u.hero.IsValid())	if (u.hero.GetCommanded) continue;
				bMil = u.IsHeirOf("Military");
				bMage = u.IsHeirOf("BaseMage");
				nLevel = u.inherentlevel;
				bHeal = u.health < u.maxhealth;

				bTrained = nLevel < nMaxLevelTrained && (bMil || bMage);
				bToLearn = nLevel < nMaxLearnLevel && bMage && pCanLearn[u.race] != 0;
				bTraining = nLevel < nMaxLevelTraining && bMil;
				if (bHeal || bTraining) nToHeal += 1;
				if (bTrained) nToBeTrained += 1;
				if (bToLearn) nToLearn += 1;

				if (bTraining && bHeal && u.health * 2 > u.maxhealth)
					bHeal = false; /// training units shuld train more before healing
				if (bTraining && bTrained) bTrained = false;
				if (bHeal && bTrained)		 bHeal = false;
				if (bHeal && bTraining)    bTraining = false;
				if (bHeal)     lToHealOut.Add(u);
				if (bTrained)	 lToBeTrained.Add(u);
				if (bTraining) lToTrain.Add(u);
				if (bToLearn) lToLearn.Add(u);
			}
			nTraining = lToHealOut.count + lToBeTrained.count + lToTrain.count + lToLearn.count;
			for (i = 0; i < olInside.count; i += 1)
			{
				Sleep(1);	nSleep = nSleep - 1;
				u = olInside[i].AsUnit;
				if (nTraining >= nMaxTraining)
				if (!u.AsHero.IsValid)
					continue;
				bMil = u.IsHeirOf("Military");
				bMage = u.IsHeirOf("BaseMage");
				nLevel = u.inherentlevel;
				bHeal = u.health < u.maxhealth;
				
				bTrained = nLevel < nMaxLevelTrained && (bMil || bMage);
				bToLearn = nLevel < nMaxLearnLevel && bMage && pCanLearn[u.race] != 0;
				bTraining = nLevel < nMaxLevelTraining && bMil;

				if (bHeal || bTraining) nToHeal += 1;
				if (bTrained) nToBeTrained += 1;
				if (bToLearn) nToLearn += 1;

				if (bTraining && bTrained) bTrained = false;
				if (bHeal && bTrained)		 bHeal = false;
				if (bHeal && bTraining)    bTraining = false;
				if (bHeal)     lToHealIn.Add(u);
				if (bTrained)	 lToBeTrained.Add(u);
				if (bTraining) lToTrain.Add(u);
				if (bToLearn) lToLearn.Add(u);
				if (bHeal || bTrained || bTraining || bToLearn)
					nTraining += 1;
			}
			///---- CHECK FOR SINGLE UNIT TO TRAIN
			if (lToTrain.count == 1)
			{	/// a single unit can not train -> put in other group
				u = lToTrain[0].AsUnit;
				if (u.inherentlevel < nMaxLevelTrained)
					lToBeTrained.Add(u);
				else
					if (u.health < u.maxhealth)
						if (u.InHolder)
							lToHealIn.Add(u);
						else
							lToHealOut.Add(u);
					else
						nToHeal = nToHeal - 1;
				lToTrain.Clear;
				//pr ("Single unit to train!");
			}
			/// CHECK FOR SINGLE INJURED HEALER
			if (lToTrain.count == 0 && nToHeal == 1 && lHealers.count == 1)
			{
				u = lHealers[0].AsUnit;
				if (u.health < u.maxhealth)
				{	/// a single healer can not heal himself
					nToHeal = 0;
					if (u.inherentlevel < nMaxLevelTrained)
						lToBeTrained.Add(u);
					lToHealIn.Clear;
					lToHealOut.Clear;
					//pr ("Single healer can not heal himself!");
				}
			}
			if (nToHeal == 0)
			{	///	put roaming healers in the townhall
				lHealers.RemoveList(lToBeTrained);
				lHealers.Clear();
			}	else {
				lToHealIn.RemoveList(lHealers);
				lToHealOut.RemoveList(lHealers);
			}
			///---- DISCARD	TRAINERS IF NO WORK FOR THEM
			if (lTrainers.count > 0) if (nToBeTrained == 0 || (nToBeTrained == 1 && lTrainers.count == 1))
			{
				bool bNoTrainers = true;
				if (nToBeTrained == 1)	{	 /// lTrainers.count == 1
					u = lTrainers[0].AsUnit;
					if (u.inherentlevel >= nMaxLevelTrained)
						bNoTrainers = false; /// the single unit to train is not the trainner
				}
				if (bNoTrainers) {
					lTrainers.Clear;
					lToBeTrained.Clear;
					nToBeTrained = 0;
				}
			}
			if (lTrainers.count > 4 * nToBeTrained)
			{
				ol = lTrainers;
				ol.RemoveList(olOutside);	// trainrs IN
				lTrainers.RemoveList(ol);	// trainrs OUT
				i = 4 * nToBeTrained - lTrainers.count;
				for (i -= 1; i >= 0; i -= 1)
					lTrainers.Add(ol[i]);
			}
			if (lHealers.count > nTraining)
			{
				ol = lHealers;
				ol.RemoveList(olOutside);	// healers IN
				lHealers.RemoveList(ol);	// healers OUT
				i = nTraining - lHealers.count;
				for (i -= 1; i >= 0; i -= 1)
					lHealers.Add(ol[i]);
			}

			////-------- THE REST...
			lNewTraining.Clear;
			lNewTraining.AddList(lHealers);
			lNewTraining.AddList(lTrainers);
			lNewTraining.AddList(lToTrain);
			lNewTraining.AddList(lToLearn);
			if (nToLearn > 0)
				lNewTraining.Add(uLearnFrom);

			//pr("ToBeTrained: " + nToBeTrained + ", Trainers: " + lTrainers.count);
			//pr("ToLern: " + nToLearn + ",   " + lToLearn.count);

			if (nToBeTrained <= lTrainers.count)
				lNewTraining.AddList(lToBeTrained);
			else {
				nCount = lToBeTrained.count;
				lToBeTrained.RemoveList(lTrainers);
				lToBeTrained.RemoveList(lHealers);
				nCount = 1 + lTrainers.count - (nCount - lToBeTrained.count);
				if (nCount > lToBeTrained.count)
					nCount = lToBeTrained.count;
				if (nCount > 0)
				{
					// heros should always be trained
					for (i = 0; i < lToBeTrained.count; i += 1)
					{
						u = lToBeTrained[i].AsUnit;
						if (u.AsHero.IsValid)
							lNewTraining.Add(u);
						Sleep(1);
					}
					ol = lToBeTrained;
					ol.RemoveList(olInside);
					i = ol.count;
					if (i >= nCount)
						for (i = 0; i < nCount; i += 1)	{
							lNewTraining.Add(ol[i]);
							Sleep(1);
						}
					else {
						lNewTraining.AddList(ol);
						nCount -= i;
						lToBeTrained.RemoveList(ol);
						if (nCount > 1)
							nCount -= 1;
						for (i = 0; i < nCount; i += 1)	{
							lNewTraining.Add(lToBeTrained[i]);
							Sleep(1);
						}
					}
				}
			}

			nMaxHealOutside = 0;
			if (lHealers.count > 0)
			{
				int nCoef = 2;
				if (.settlement.food <= 0)
					nCoef = 1000;
				nMaxHealOutside = nCoef * lHealers.count;
			}

			nCount = 0;
			for (i = 0; i < lNewTraining.count; i += 1)
			{
				u = lNewTraining[i].AsUnit;
				if (u.health < u.maxhealth)
					nCount = nCount + 1;
				Sleep(1);	nSleep = nSleep - 1;
			}
			if (nCount >= nMaxHealOutside)	{
				lToHealIn.AddList(lToHealOut);
				lToHealOut.Clear;
			}
			else
			{
				nCount = nMaxHealOutside - nCount; /// how much for heal space
				if (lToHealOut.count > nCount)
				{
					ObjList ol;
					nCount = lToHealOut.count - nCount;
					for (i = 0; i < nCount; i += 1)	{
						ol.Add(lToHealOut[i]);
						Sleep(1);	nSleep = nSleep - 1;
					}
					lToHealIn.AddList(ol);
					lToHealOut.RemoveList(ol);
				}
				else {
					ObjList ol;
					nCount = nCount - lToHealOut.count;
					if (nCount > lToHealIn.count)
						ol.AddList(lToHealIn);
					else
						for (i = 0; i < nCount; i += 1)	{
							ol.Add(lToHealIn[i]);
							Sleep(1);	nSleep = nSleep - 1;
						}
					lToHealOut.AddList(ol);
					lToHealIn.RemoveList(ol);
				}
				lNewTraining.AddList(lToHealOut);
			}
			
			if (lTrainers.count > 0)
			{	/// put Trainers in the holder if nothing to do
				for (i = 0; i < lNewTraining.count; i += 1)
				{
					u = lNewTraining[i].AsUnit;
					if (u.inherentlevel < nMaxLevelTrained)
						break;
					Sleep(1);	nSleep = nSleep - 1;
				}
				if (i >= lNewTraining.count) {
					lTrainers.RemoveList(lToHealIn);
					lTrainers.RemoveList(lToHealOut);
					lNewTraining.RemoveList(lTrainers);
					lTrainers.Clear;
				}
			}
			/// lNewTraining contains all new units outside
			/// olOutside contains all old units outside
			
			/// put not training units in the holder
			olOutside.RemoveList(lNewTraining);
			/*
			if (bAIPlayer) // detach units
				for (i = 0; i < olOutside.count; i += 1)
				{
					u = olOutside[i].AsUnit;
					if (u.AsHero.IsValid)
						u.AsHero.DetachArmy;
					else
						if (u.hero.IsValid)
							u.DetachFrom(u.hero);
				}
			*/
			olOutside.ClearDead();
			olOutside.SetCommand("enteralone", this);
			
			i = 0;
			if (lToTrain.count > 1)
				i = nMaxLevelTraining;
			if (lTrainers.count > 0) if (i < nMaxLevelTrained)
				i = nMaxLevelTrained;
			EnvWriteInt(.settlement, "MaxAutotrainLevel", i);
			
			/// training units in the holder should exit
			{
				ObjList ol;
				ol = olInside;
				ol.RemoveList(lNewTraining);
				olInside.RemoveList(ol);
				/*
				if (bAIPlayer)
				{
					SquadList sl;
					for (i = 0; i < olInside.count; i += 1)
					{
						u = olInside[i].AsUnit;
						if (u.AsHero.IsValid)
							u.AsHero.DetachArmy;
						else
							if (u.hero.IsValid)
								u.DetachFrom(u.hero);
					}
					Squadize(olInside, sl, SS_Train);
				}
				*/
				olInside.SetCommand("advancealone", ptExit);
				ol = lToTrain;
				ol.RemoveList(olInside);
				ol.SetCommand("train");
				lToTrain.RemoveList(ol);
				lToTrain.AddCommand(false, "train");

				ol = lToLearn;
				ol.RemoveList(olInside);
				ol.SetCommand("learn", uLearnFrom);
				lToLearn.RemoveList(ol);
				lToLearn.AddCommand(false, "learn", uLearnFrom);
			}
			lTraining = lNewTraining;
			lTraining.AddList(olOutside);	 /// because the hero mess in the process
		}
	}
	else
		if (lTraining.count)
		{	/// take trainig units in the holder
			lTraining.ClearDead;
			for (i = 0; i < lTraining.count; i += 1)
			{
				Unit u;
				Sleep(1);	nSleep = nSleep - 1;
				u = lTraining[i].AsUnit;
				if (u.GetCommanded)
					continue;
				if (u.hero.IsValid())	if (u.hero.GetCommanded)
					continue;
				u.SetCommand("enter", this);
			}
			lTraining.Clear;
		}
}
