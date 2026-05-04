//void

Settlement set;
int aiPlayer, nMaxSetIdx, script, i;

Sleep(500 + rand(501));

aiPlayer = AIGetPlayer();
nMaxSetIdx = MaxSetIdx;

while (true) {
	for (i = 0; i < nMaxSetIdx; i += 1) {
		set = IdxToSet(i);
		if (set.IsOwn(aiPlayer))
			if (set.EconomyScript == ES_NONE) {
				script = set.GetEconomyScript(aiPlayer);
				if (script != ES_NONE)
					set.RunEconomyScript(script);
			}
	}
	Sleep(1000);
}