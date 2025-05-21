//void, SquadList l, GAIKA g

if (l.Rewind()) {
	Squad sq;
	l.Lock();
	while (1) {
		sq = l.Cur;
		if (sq.GAIKAIn == g)
			if (sq.State != SS_Flee)
				sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
			else if (!g.settlement.IsValid)
				sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
			else
				sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", g.settlement.GetCentralBuilding());
		else {
			Obj teleport;
			int sqPlayer, LsaPathLen;

			sqPlayer = sq.Player;

			if (AIVar(sqPlayer, AIV_UseTeleports) != 0)
				teleport = FindTeleport(sqPlayer, sq.pos, g.Center);

			if (teleport.IsValid)
				LsaPathLen = 1;
			else
				LsaPathLen = CheckLsaPath(sq.GAIKAIn.LSA, g.LSA, sqPlayer);

			if (LsaPathLen == 1) {
				int state;
				str cmd;
				if (sq.State == SS_Flee) {
					cmd = "move";
					state = SS_Flee;
				}
				else if (sq.Leader.AsHero().IsValid) {
					cmd = "sneak";
					state = SS_Approach;
				}
				else if (GetTime() < 10 * 60000) {//independent outsposts are quite dangerous in early game
					cmd = "move";
					state = SS_Approach;
				}
				else {
					cmd = "advance";
					state = SS_Approach;
				}
				if (teleport.IsValid)
					sq.UseTeleport(teleport, state, cmd, g.GetDestPoint(sq.Leader));
				else
					sq.SetCmd(state, 0, SF_ADVCHOOSER, cmd, g.GetDestPoint(sq.Leader));
			}
			else if (LsaPathLen == 3) {
				int state;
				str cmd;
				Ship ship;
				if (sq.State == SS_Flee) {
					cmd = "move";
					state = SS_Flee;
				}
				else {
					if (sq.Leader.AsHero().IsValid)
						cmd = "sneak";
					else if (GetTime() < 600000)
						cmd = "move";
					else
						cmd = "advance";
					state = SS_Approach;
				}
				ship = PrepareAiTransportShip(sq.GAIKAIn.LSA, g.LSA, sqPlayer, cmd, g.Center);
				if (!ship.IsValid())
					return;
				else if (ship.GetFlags(UNITFLAG_NOAI))
					return;
				ship.GetSquad().DelOrder();
				if (sq.Leader.AsHero().IsValid)
					sq.SetCmd(state, 0, 0, "boardshiphero", ship);
				else
					sq.SetCmd(state, 0, 0, "boardship", ship);
			}
		}
		if (!l.Next())
			break;
	}
	l.Unlock();
}