//void, Settlement set

//plan: focus on a sturdy group of spearmen supported by archers and druids and take bear teeth to improve damage

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olSpearmen, olArchers, olDruids;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsEpicAttack;
aSkillLevels[0] = 10;

//hero + spears + free beer + 2 druids + 4 exploring archers
{
	int nCount, nDruids = 2, nExploringUnits = 4, i, gold, food;
	bool bSpears1 = false, bFreeBeer = false;
	str cmd = "trainGArcher";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bSpears1 || !bFreeBeer || olDruids.count < nDruids || i < nExploringUnits)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bSpears1)
			bSpears1 = set.TSResearch("Gaul Spearman");
		if (!bFreeBeer)
			bFreeBeer = set.TSResearch("Free Beer");
		if (olDruids.count < nDruids) {
			nCount = nDruids - olDruids.count;
			olDruids.AddList(set.TSTempleRecruit(nCount));
		}
		if (i < nExploringUnits) {
			barrack = set.BestBarrack(5);
			if (barrack.IsValid)
				if (!barrack.IsBroken)
					if (GetCmdCost(cmd, gold, food)) {
						set.SpentGoldOnArmy(gold + food / 2);
						barrack.ExecCmd(cmd, ptDummy, objDummy, false);
					}
			i += 1;
		}
		Sleep(4100 + rand(15) * 100);
	}
	if (hero.IsAlive) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//barrack level 1 + bear teeth
{
	bool bBarrack1 = false, bBearTeeth = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || !bBearTeeth)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bBearTeeth)
			bBearTeeth = set.TSResearch("Nordic trade routes");
		Sleep(4100 + rand(15) * 100);
	}
}

//iron spears + 3 druids
{
	bool bSpears2 = false;
	int nCount, nDruids = 5;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bSpears2 || olDruids.count < nDruids)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bSpears2)
			bSpears2 = set.TSResearch("Gaul Iron Spearheads");
		if (olDruids.count < nDruids) {
			nCount = nDruids - olDruids.count;
			olDruids.AddList(set.TSTempleRecruit(nCount));
		}
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 2 + 25 spearmen + 20 archers
{
	int nCount, nSpearmen = 20, nArchers = 15;
	bool bBarrack2 = false;
	str supportCmd = "GAddPop";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olSpearmen.count < nSpearmen || olArchers.count < nArchers)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2) {
			if (olSpearmen.count < nSpearmen) {
				nCount = nSpearmen - olSpearmen.count;
				olSpearmen.AddList(set.TSRecruitArmy("GSpearman", nCount));
			}
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("GArcher", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olSpearmen.SetCommand("enter", set.GetCentralBuilding());
		olArchers.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
}

//give control back to AI
if (bHeroScript)
	AIBreakScript(heroScriptId);
if (hero.IsAlive) {
	int i, attached;
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);
	hero.SetCommand("enter", set.GetCentralBuilding());
	hero.SetNoAIFlag(false);
	olSpearmen.SetCommand("attach", hero);
	olArchers.SetCommand("attach", hero);
	olDruids.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
}

olSpearmen.ClearDead();
olArchers.ClearDead();
olDruids.ClearDead();
SetNoAIFlag(olSpearmen, false);
SetNoAIFlag(olArchers, false);
SetNoAIFlag(olDruids, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);