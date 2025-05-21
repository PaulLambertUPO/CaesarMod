// void
int   i;
bool bFirstTime = true;
int nMaxPriority;

int AIPlayer; AIPlayer = AIGetPlayer();
nMaxPriority = MaxGAIKAPriority;
while (1)
{
//  pr("Starting GAIKA Prioritization for player " + AIPlayer);
  for (i = 1; i < GAIKACount; i += 1) {
    int nOld, nNew;
    GAIKA g; g = GetGAIKA(i);
    nOld = g.GetPriority(AIPlayer);
		if (nOld >= nMaxPriority)
			continue; // adventure boosted
    nNew = g.CalcPriority(AIPlayer);
    if (nOld != nNew) {
      if (nOld != 0) {
        int nStep; nStep = (nNew - nOld) / 10;
        if (nStep == 0) if (nNew > nOld) nStep = 1; else nStep = -1;
        nNew = nOld + nStep;
      }
      g.SetPriority(AIPlayer, nNew);
      //if (!bFirstTime) pr("Player " + AIPlayer + " GAIKA " + g.ID + " priority changed from " + nOld + " to " + nNew);
    }
    if (bFirstTime) Sleep(1); else Sleep(200);
  }
  bFirstTime = false;
//  pr("Done GAIKA Prioritization for player " + AIPlayer);
}
