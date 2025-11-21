//void

GAIKA g;
int aiPlayer, gaikas, nOld, nNew, i;
bool afterFirstTime = false;

Sleep(rand(51) + 100);

aiPlayer = AIGetPlayer();
gaikas = GAIKACount;

while (1) {
	for (i = 1; i < gaikas; i += 1) {
		g = GetGAIKA(i);
		nOld = g.GetPriority(aiPlayer);
		if (nOld < MaxGAIKAPriority) {//priority can reach/exceed the max with adventure sequences
			nNew = g.CalcPriority(aiPlayer);
			if (nOld != nNew) {
				if (nOld != 0) {
					int nStep;
					nStep = (nNew - nOld) / 10;
					if (nStep == 0)
						if (nNew > nOld)
							nStep = 1;
						else
							nStep = -1;
					nNew = nOld + nStep;
				}
				g.SetPriority(aiPlayer, nNew);
			}
		}
		if (afterFirstTime)
			Sleep(250);
	}
	afterFirstTime = true;
}