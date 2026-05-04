//int, int aiPlayer, GAIKA g, int *pOverneed

int own, ally, enemy, enemy_hidden;

g.Eval(AI_COMING + AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);

pOverneed = own - g.MaxNeed(aiPlayer, own, ally, enemy);

return own - g.MinNeed(aiPlayer, own, ally, enemy);//interpreted as zero if negative