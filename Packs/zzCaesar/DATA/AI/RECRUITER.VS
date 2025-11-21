//void

int aiPlayer, nSleepRecruit, nMaxAttentionPoints, nLastGaika;
int nMilEval, nAvail, nAttentionPoints, nHomeGaikaId, gLsa, nMinNeed, nMaxNeed, nSent, own, ally, enemy, enemy_hidden, i;
bool bAssUnderFire, bStrongholdGaika, bNotSatisfied, bAllSatisfied = false;
GAIKA g;
Settlement set;

Sleep(rand(1001) + 500);

aiPlayer = AIGetPlayer();
nSleepRecruit = AIVar(aiPlayer, AIV_Sleep_Recruit);
nMaxAttentionPoints = MAX(1, AIVar(aiPlayer, AIV_MaxAttentionPoints));
nLastGaika = GAIKACount - 1;

while (!GetGAIKA(nLastGaika).Prioritized(aiPlayer))
	Sleep(2000);

while (1) {
	nMilEval = MilEval(aiPlayer);//this is without sentries

	if (nMilEval >= 1) {
		nAttentionPoints = 0;
		bNotSatisfied = false;

		nAvail = nMilEval;

		nHomeGaikaId = EnvReadInt(aiPlayer, "HomeGaika");//check home and try to find another one if lost
		if (nHomeGaikaId <= 0) {
			Settlement s;
			point pt;
			s = NearestStronghold(pt, aiPlayer);
			if (s.IsValid) {
				nHomeGaikaId = s.GetGaika().ID;
				EnvWriteInt(aiPlayer, "HomeGaika", nHomeGaikaId);
			}
		}
		else if (!GetGAIKA(nHomeGaikaId).settlement.IsOwn(aiPlayer)) {//home settlement is always valid
			Settlement s;
			point pt;
			s = NearestStronghold(pt, aiPlayer);
			if (s.IsValid) {
				nHomeGaikaId = s.GetGaika().ID;
				EnvWriteInt(aiPlayer, "HomeGaika", nHomeGaikaId);
			}
		}

		for (i = 0; i <= nLastGaika; i += 1) {
			bAssUnderFire = false;

			if (i == 0) {//always check the home GAIKA first
				if (nHomeGaikaId <= 0)
					continue;
				g = GetGAIKA(nHomeGaikaId);
			}
			else {
				g = LAIKA(aiPlayer, i);
				if (g.ID == nHomeGaikaId)
					continue;
			}
			set = g.settlement;

			if (set.IsValid)
				bStrongholdGaika = set.IsStronghold;
			else
				bStrongholdGaika = false;

			if (g.ID != nHomeGaikaId) {
				if (!bStrongholdGaika)
					if (nAttentionPoints >= nMaxAttentionPoints)//check for allied strongholds
						continue;
				if (!g.Explored(aiPlayer))
					if (!g.CanExplore(aiPlayer))
						continue;
			}
			if (!set.IsValid)
				if (g.Empty)
					if (g.Explored(aiPlayer))
						continue;

			g.Eval(AI_COMING + AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);

			if (bStrongholdGaika)//calculate army needs
				if (own + ally < enemy)
					if (set.IsOwn(aiPlayer))//validity check is already done through bStrongholdGaika
						bAssUnderFire = true;
					else if (set.IsAlly(aiPlayer))
						bAssUnderFire = true;

			if (!bAssUnderFire)
				if (nAttentionPoints >= nMaxAttentionPoints)
					continue;

			if (!bStrongholdGaika)//count "attention points"
				if (enemy > 0) {
					if (own > 0)
						nAttentionPoints += 1;
					else if (set.IsValid)
						if (set.IsOwn(aiPlayer))
							if (g.Eval(AI_STAYING, aiPlayer, AI_ENEMY) > 0)
								nAttentionPoints += 1;
				}
				else if (own > 0)
					if (set.IsValid)
						if (set.IsEnemy(aiPlayer))
							if (!set.IsIndependent)
								nAttentionPoints += 1;

			nMinNeed = g.MinNeed(aiPlayer, own, ally, enemy);
			nMaxNeed = g.MaxNeed(aiPlayer, own, ally, enemy);

			if (own + ally >= nMinNeed) {
				if (!bAllSatisfied)
					continue;
				if (!set.IsValid)
					continue;
				if (set.IsAlly(aiPlayer))
					continue;
			}

			if (bAssUnderFire)
				nMinNeed = 1;
			else if (nAvail < nMinNeed - (own + ally))//quick "no chance" filter
				continue;

			if (!bStrongholdGaika)
				if (enemy < 1000)
					if (set.IsValid)
						if (set.IsAlly(aiPlayer))
							continue;

			gLsa = g.LSA;
			if (IsWaterLsa(gLsa))
				if (Ships(aiPlayer, gLsa) <= 0) {
					IncShipNeeds(aiPlayer, gLsa);
					continue;
				}

			//LAIKA flag filters
			if (g.NoRecruit(aiPlayer))
				continue;
			if (g.NoAttack(aiPlayer))
				if (set.IsValid) {
					if (set.IsEnemy(aiPlayer))
						continue;
				}
				else if (enemy > 0)
					if (own <= 0)
						if (ally <= 0)
							continue;

			if (bAllSatisfied)
				nMaxNeed = 10000000;

			bAllSatisfied = false;
			bNotSatisfied = true;

			//recruit (send army)
			if (bAssUnderFire) {
				EnvWriteInt(aiPlayer, "AssUnderFireGaika", g.ID);
				nSent = g.Recruit(aiPlayer, 1, nMaxNeed - own, nAvail);
				EnvWriteInt(aiPlayer, "AssUnderFireGaika", 0);
			}
			else
				nSent = g.Recruit(aiPlayer, nMinNeed - (own + ally), nMaxNeed - own, nAvail);

			if (nSent <= 0) {
				int me;
				if (IsWaterLsa(gLsa))
					if (g.Explored(aiPlayer))
						IncShipNeeds(aiPlayer, gLsa);
				if (nAvail <= 0)
					break;
				Sleep(nSleepRecruit);
				me = MilEval(aiPlayer);//military power can change during the sleep
				if (me > nMilEval) {
					nAvail += me - nMilEval;
					nMilEval = me;
				}
				continue;
			}

			break;
		}

		bAllSatisfied = !bNotSatisfied;
	}

	Sleep(nSleepRecruit);
}