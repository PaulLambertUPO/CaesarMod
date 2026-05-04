//bool, int aiPlayer, GAIKA gSrc, GAIKA gDst, GAIKA gMAIKA

int own, ally, enemy, enemy_hidden;

gMAIKA.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);

if (own + ally < gMAIKA.MinNeed(aiPlayer, own, ally, enemy)) {
	int nDstPriority;

	nDstPriority = gDst.GetPriority(aiPlayer);

	if (gMAIKA.GetPriority(aiPlayer) < nDstPriority)
		gMAIKA.SetPriority(aiPlayer, MIN(MaxGAIKAPriority, nDstPriority * 3 / 2));

	return false;
}

return true;