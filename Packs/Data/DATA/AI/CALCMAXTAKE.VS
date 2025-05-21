//int, int idPlayer, GAIKA g, int *pOverneed

int own, ally, enemy, enemy_hidden;
int nMinNeed, nMaxNeed;

g.Eval(AI_COMING + AI_STAYING, idPlayer, own, ally, enemy, enemy_hidden);

nMinNeed = g.MinNeed(idPlayer, own, ally, enemy);
nMaxNeed = g.MaxNeed(idPlayer, own, ally, enemy);

pOverneed = own - nMaxNeed;

return own - nMinNeed; // will be interpreted as zero if negative
