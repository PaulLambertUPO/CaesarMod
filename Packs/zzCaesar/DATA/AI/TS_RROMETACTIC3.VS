//void, Settlement set

//plan: focus on a well-rounded combination of principles and priests, take gladiator shows to improve hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olPrinciples, olPriests;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

//gladiator shows + pikes + 3 exploring hastati
{
	int nExploringUnits = 3, i, gold, food;
	bool bGladiatorShows = false, bPikes = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bPikes || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows");
		if (!bPikes)
			bPikes = set.TSResearch("Roman Principle");
		if (i < nExploringUnits) {
			barrack = set.BestBarrack(5);
			if (barrack.IsValid)
				if (GetCmdCost(cmd, gold, food)) {
					set.SpentGoldOnArmy(gold + food / 2);
					barrack.ExecCmd(cmd, ptDummy, objDummy, false);
				}
			i += 1;
		}
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + arrows + barrack level 1
{
	bool bArrows = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bArrows || !bBarrack1)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");//archers are researched in order to be already recruitable when the script ends
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
	if (hero.IsValid) {
		Obj objDummy;
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//20 principles + 5 priests
{
	int nCount, nPrinciples = 20, nPriests = 5;
	str supportCmd1 = "RAddPop", supportCmd2 = "buyfoodforgold";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (olPrinciples.count < nPrinciples || olPriests.count < nPriests)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olPrinciples.count < nPrinciples) {
			nCount = nPrinciples - olPrinciples.count;
			olPrinciples.AddList(set.TSRecruitArmy("RPrinciple", nCount));
		}
		if (olPriests.count < nPriests) {
			nCount = nPriests - olPriests.count;
			olPriests.AddList(set.TSTempleRecruit(nCount));
		}
		if (set.CanAfford(supportCmd1))
			set.TSResearch(supportCmd1);
		if (set.CanAfford(supportCmd2))
			set.TSResearch(supportCmd2);
		olPrinciples.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
}

//give control back to AI
if (bHeroScript)
	AIBreakScript(heroScriptId);
if (hero.IsValid)
	if (hero.IsAlive) {
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		hero.SetCommand("enter", set.GetCentralBuilding());
		hero.SetNoAIFlag(false);
		olPrinciples.SetCommand("attach", hero);
		olPriests.SetCommand("attach", hero);
		Sleep(5000);
	}

olPrinciples.ClearDead();
olPriests.ClearDead();
SetNoAIFlag(olPrinciples, false);
SetNoAIFlag(olPriests, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);