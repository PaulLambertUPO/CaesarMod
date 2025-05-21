//bool, int idPlayer, GAIKA gSrc, GAIKA gDst, GAIKA gMAIKA
int own, ally, enemy, enemy_hidden, nMinNeed, i;
gMAIKA.Eval(AI_STAYING, idPlayer, own, ally, enemy, enemy_hidden);
nMinNeed = gMAIKA.MinNeed(idPlayer, own, ally, enemy);

//pr("MAIKA<"+gSrc.ID+"-"+gMAIKA.ID+"-"+gDst.ID+">: Own: "+own+" Needed: "+nMinNeed);

if (own + ally < nMinNeed) {
  int nDstPriority, nMAIKAPriority;
  nDstPriority = gDst.GetPriority(idPlayer);
  nMAIKAPriority = gMAIKA.GetPriority(idPlayer);
  if (nMAIKAPriority < nDstPriority) {
    i = nDstPriority * 3 / 2;
    if (i >= MaxGAIKAPriority)
			i = MaxGAIKAPriority;
    gMAIKA.SetPriority(idPlayer, i);
  }
//  pr("  BMAIKA");
  return false;
}
//pr("  OK");
return true;