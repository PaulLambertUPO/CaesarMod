//void, Settlement set

//plan: focus on a firm group of principles, take military academy to give a huge boost to hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olPrinciples;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 8;
aSkillLevels[1] = 4;

//gladiator shows + pikes + 2 exploring hastati
{
	int nExploringUnits = 2, i, gold, food;
	bool bGladiatorShows = false, bPikes = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bPikes || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows2");
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

//military academy + arrows + barrack level 1
{
	bool bMilitaryAcademy = false, bArrows = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bMilitaryAcademy || !bArrows || !bBarrack1)) {
		if (!bMilitaryAcademy)
			bMilitaryAcademy = set.TSResearch("Military Academy");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");//archers are researched in order to be already recruitable when the script ends
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + 15 principles
{
	int nCount, nPrinciples = 15;
	str supportCmd = "RAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || olPrinciples.count < nPrinciples)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		else {
			if (!bHeroScript) {
				Obj objDummy;
				ObjList ol;
				ol.Add(hero);
				hero.KillCommand();
				hero.TSAdvHeroSkills(aSkills, aSkillLevels);
				heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
				bHeroScript = true;
			}
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
			if (olPrinciples.count < nPrinciples) {
				nCount = nPrinciples - olPrinciples.count;
				olPrinciples.AddList(set.TSRecruitArmy("RPrinciple", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
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
		Sleep(5000);
	}

olPrinciples.ClearDead();
SetNoAIFlag(olPrinciples, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);