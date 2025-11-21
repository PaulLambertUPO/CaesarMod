//void, GAIKA g, int aiPlayer

int own, ally, enemy, enemy_hidden, nMinNeed;

g.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
nMinNeed = g.MinNeed(aiPlayer, own, ally, enemy);

if (own + ally < nMinNeed)
	if (own + ally + g.Eval(AI_LEAVING, aiPlayer) >= nMinNeed) {
		SquadList SL;
		Squad sq;

		g.GetSquads(SL, AI_LEAVING, aiPlayer);

		SL.Lock();
		while (!SL.EOL) {
			sq = SL.Cur;
			if (sq.State != SS_Flee) {
				sq.SetState(SS_IDLE);
				sq.SendTo(g, 1);
			}
			SL.Next();
		}
		SL.Unlock();
	}