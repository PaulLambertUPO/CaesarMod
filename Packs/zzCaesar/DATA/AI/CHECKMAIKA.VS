//bool, int idPlayer, GAIKA gSrc, GAIKA gDst, GAIKA gMAIKA

int own, ally, enemy, enemy_hidden;

gMAIKA.Eval(AI_STAYING, idPlayer, own, ally, enemy, enemy_hidden);

if (own + ally < gMAIKA.MinNeed(idPlayer, own, ally, enemy)) {
	int nDstPriority;

	nDstPriority = gDst.GetPriority(idPlayer);

	if (gMAIKA.GetPriority(idPlayer) < nDstPriority)
		gMAIKA.SetPriority(idPlayer, MIN(MaxGAIKAPriority, nDstPriority * 3 / 2));

	return false;
}

return true;