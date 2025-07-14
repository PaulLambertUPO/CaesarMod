//void

if (MapSize() >= 16000) {//avoid using tactic if the map is small
	Settlement set;
	int AIPlayer, nMaxSetIdx, script, i;

	Sleep(500 + rand(501));

	AIPlayer = AIGetPlayer();
	nMaxSetIdx = MaxSetIdx();

	while (1) {
		for (i = 0; i < nMaxSetIdx; i += 1) {
			set = IdxToSet(i);
			if (set.IsOwn(AIPlayer))
				if (set.TacticScript == TS_NONE) {
					script = set.GetTacticScript(AIPlayer);
					if (script != TS_NONE)
						set.RunTacticScript(script);
				}
		}
		Sleep(1000);
	}
}