//void

bool bAllSatisfied = false;

Sleep(rand(1000) + 300);

while (1) {
	bool bFindNewHome = false, bNotSatisfied = false;
	int AIPlayer, nHomeGaikaID, i, nAvail, nMilEval, nAttentionPoints, nMaxAttentionPoints;

	AIPlayer = AIGetPlayer();
	nMaxAttentionPoints = MAX(1, AIVar(AIPlayer, AIV_MaxAttentionPoints));

	nMilEval = MilEval(AIPlayer);//this is without sentries
	if (nMilEval < 1) {
		Sleep(2000);
		continue;
	}
	nAvail = nMilEval;

	if (!GetGAIKA(GAIKACount - 1).Prioritized(AIPlayer)) {
		Sleep(1000);
		continue;
	}

	//check home and try to find another one if lost
	nHomeGaikaID = EnvReadInt(AIPlayer, "HomeGaika");
	if (nHomeGaikaID > 0)
		if (!GetGAIKA(nHomeGaikaID).settlement.IsOwn(AIPlayer))
			bFindNewHome = true;
	if (bFindNewHome || nHomeGaikaID <= 0) {
		Settlement set;
		point pt;
		set = NearestStronghold(pt, AIPlayer);
		if (set.IsValid) {
			nHomeGaikaID = set.GetGaika().ID;
			EnvWriteInt(AIPlayer, "HomeGaika", nHomeGaikaID);
		}
	}

	for (i = 0; i < GAIKACount; i += 1) {
		GAIKA g;
		Settlement set;
		int own, ally, enemy, enemy_hidden;
		int nMinNeed, nMaxNeed, nSent;
		bool bAssUnderFire = false, bAttention = false, bStrongholdGaika;

		//always check the home GAIKA first (no matter the priority)
		if (i == 0) {
			if (nHomeGaikaID <= 0)
				continue;
			g = GetGAIKA(nHomeGaikaID);
		}
		else {
			g = LAIKA(AIPlayer, i);
			if (g.ID == nHomeGaikaID)
				continue;
		}
		set = g.settlement;

		bStrongholdGaika = set.IsStronghold;

		if (nAttentionPoints >= nMaxAttentionPoints)
			if (g.ID != nHomeGaikaID)
				if (!bStrongholdGaika)//check for allied strongholds
					continue;

		if (g.ID != nHomeGaikaID)
			if (!g.Explored(AIPlayer))
				if (!g.CanExplore(AIPlayer))
					continue;

		if (!set.IsValid)
			if (g.Empty)
				if (g.Explored(AIPlayer))
					continue;

		g.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);

		//calc army needs
		if (bStrongholdGaika)
			if (own + ally < enemy)
				if (set.IsOwn(AIPlayer))
					bAssUnderFire = true;
				else if (set.IsAlly(AIPlayer))
					bAssUnderFire = true;

		if (!bAssUnderFire)
			if (nAttentionPoints >= nMaxAttentionPoints)
				continue;

		//count "attention points"
		if (own > 0)
			if (enemy > 0)
				bAttention = true;
			else if (set.IsEnemy(AIPlayer))
				if (!set.IsIndependent)
					bAttention = true;
		if (!bAttention)
			if (enemy > 0)
				if (set.IsOwn(AIPlayer))
					if (g.Eval(AI_STAYING, AIPlayer, AI_ENEMY) > 0)
						bAttention = true;
		if (bAttention)
			if (!bStrongholdGaika)
				nAttentionPoints += 1;

		nMinNeed = g.MinNeed(AIPlayer, own, ally, enemy);
		nMaxNeed = g.MaxNeed(AIPlayer, own, ally, enemy);

		if (own + ally >= nMinNeed) {
			if (!bAllSatisfied)
				continue;
			if (!set.IsValid)
				continue;
			if (set.IsAlly(AIPlayer))
				continue;
		}

		if (!bStrongholdGaika)
			if (enemy < 1000)
				if (set.IsValid)
					if (set.IsAlly(AIPlayer))
						continue;

		if (bAssUnderFire)
			nMinNeed = 1;

		//quick "no chance" filter
		if (!bAssUnderFire)
			if (nAvail < nMinNeed - (own + ally))
				continue;
		if (IsWaterLsa(g.LSA))
			if (Ships(AIPlayer, g.LSA) == 0) {
				IncShipNeeds(AIPlayer, g.LSA);
				continue;
			}

		//LAIKA flags filters
		if (g.NoRecruit(AIPlayer))
			continue;
		if (g.NoAttack(AIPlayer)) {
			if (set.IsEnemy(AIPlayer))
				continue;
			if (!set.IsValid)
				if (enemy > 0)
					if (own == 0)
						if (ally == 0)
							continue;
		}

		if (bAllSatisfied)
			nMaxNeed = 10000000;

		bAllSatisfied = false;
		bNotSatisfied = true;

		//recruit
		if (bAssUnderFire) {
			EnvWriteInt(AIPlayer, "AssUnderFireGaika", g.ID);
			nSent = g.Recruit(AIPlayer, 1, nMaxNeed - own, nAvail);
			EnvWriteInt(AIPlayer, "AssUnderFireGaika", 0);
		}
		else
			nSent = g.Recruit(AIPlayer, nMinNeed - (own + ally), nMaxNeed - own, nAvail);

		if (nSent == 0) {
			int me;
			if (IsWaterLsa(g.LSA))
				if (g.Explored(AIPlayer))
					IncShipNeeds(AIPlayer, g.LSA);
			if (nAvail == 0)
				break;
			Sleep(AIVar(AIPlayer, AIV_Sleep_Recruit));
			me = MilEval(AIPlayer);
			if (me > nMilEval) {
				nAvail += me - nMilEval;
				nMilEval = me;
			}
			continue;
		}

		break;
	}

	bAllSatisfied = !bNotSatisfied;

	Sleep(AIVar(AIPlayer, AIV_Sleep_Recruit));
}