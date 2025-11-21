//int, int idPlayer, GAIKA g, int *pOverneed

int own, ally, enemy, enemy_hidden;

g.Eval(AI_COMING + AI_STAYING, idPlayer, own, ally, enemy, enemy_hidden);

pOverneed = own - g.MaxNeed(idPlayer, own, ally, enemy);

return own - g.MinNeed(idPlayer, own, ally, enemy);//interpreted as zero if negative