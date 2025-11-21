//void, GAIKA g, int aiPlayer

//called by GAIKAMonitor, this script coordinates 2 or more squads to make them wait and approach the Gaika to join forces, unless they are too weak or already strong enough

SquadList SL;

g.GetSquads(SL, AI_COMING, aiPlayer, AI_OWN + AI_ALLY);

if (!SL.EOL) {
	Squad sq;

	if (SL.Size > 1) {
		int own, ally, enemy, enemy_hidden, nMinNeed, ownAndAlly;

		g.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
		nMinNeed = g.MinNeed(aiPlayer, own, ally, enemy);
		ownAndAlly = own + ally;

		if (ownAndAlly < nMinNeed) {
			point gCenter;
			int gLsa, incoming, nDist, nMaxDist, nMinDist = 2000000;

			gCenter = g.Center;
			gLsa = g.LSA;

			SL.Lock();
			for (SL.Rewind(); !SL.EOL; SL.Next()) {
				sq = SL.Cur;
				if (!sq.TestFlags(SF_PEACEFUL))
					if (!sq.TestFlags(SF_NOAI)) {
						incoming += sq.Eval();
						if (sq.GAIKAIn.LSA == gLsa) {
							nDist = sq.pos.Dist(gCenter);
							if (nDist < nMinDist)
								nMinDist = nDist;
							if (nDist > nMaxDist)
								nMaxDist = nDist;
						}
					}
			}
			SL.Unlock();

			if (ownAndAlly + incoming >= nMinNeed) {//the 256 used below is the tolerated delta distance in pixels
				int sqCloseEval, sqState, stateAppr;

				SL.Lock();
				for (SL.Rewind(); !SL.EOL; SL.Next()) {
					sq = SL.Cur;
					if (!sq.TestFlags(SF_PEACEFUL))
						if (!sq.TestFlags(SF_NOAI))
							if (sq.GAIKAIn.LSA == gLsa)
								if (sq.pos.Dist(gCenter) <= nMinDist + 256) {
									sqCloseEval += sq.Eval();
									if (ownAndAlly + sqCloseEval >= nMinNeed) {//do not wait if the nearest squads are strong enough
										for (SL.Rewind(); !SL.EOL; SL.Next()) {
											sq = SL.Cur;
											if (sq.State == SS_ApproachWait)
												if (sq.Player == aiPlayer)
													sq.SendTo(g, 100);
										}
										SL.Unlock();
										return;
									}
								}
				}
				
				for (SL.Rewind(); !SL.EOL; SL.Next()) {
					sq = SL.Cur;
					if (sq.Player == aiPlayer) {
						sqState = sq.State;
						if (sqState == SS_Approach || sqState == SS_ApproachWait)
							if (sq.GAIKAIn.LSA == gLsa) {
								nDist = sq.pos.Dist(gCenter);
								if (nDist > nMinDist + 256)
									stateAppr = SS_Approach;
								else if (nDist < nMaxDist - 256)
									stateAppr = SS_ApproachWait;
								else
									stateAppr = SS_Approach;
								if (sqState != stateAppr)
									if (stateAppr == SS_Approach)
										sq.SendTo(g, 100);
									else
										sq.ClrCmd(SS_ApproachWait, 0, SF_ADVCHOOSER);
							}
					}
				}
				SL.Unlock();
			}
			else {//do not wait if all squads are not strong enough
				SL.Lock();
				for (SL.Rewind(); !SL.EOL; SL.Next()) {
					sq = SL.Cur;
					if (sq.State == SS_ApproachWait)
						if (sq.Player == aiPlayer)
							sq.SendTo(g, 100);
				}
				SL.Unlock();
			}
		}
		else {
			SL.Lock();
			for (SL.Rewind(); !SL.EOL; SL.Next()) {
				sq = SL.Cur;
				if (sq.State == SS_ApproachWait)
					if (sq.Player == aiPlayer)
						sq.SendTo(g, 100);
			}
			SL.Unlock();
		}
	}
	else {
		SL.Lock();
		for (SL.Rewind(); !SL.EOL; SL.Next()) {
			sq = SL.Cur;
			if (sq.State == SS_ApproachWait)
				if (sq.Player == aiPlayer)
					sq.SendTo(g, 100);
		}
		SL.Unlock();
	}
}