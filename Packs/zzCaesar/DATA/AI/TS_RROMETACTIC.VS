//void, Settlement set

//plan: focus on a lethal combination of hastati and archers, take gladiator shows to improve hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHastati, olArchers;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

//gladiator shows + arrows + free wine + 3 exploring hastati
{
	int nExploringUnits = 3, i, gold, food;
	bool bGladiatorShows = false, bArrows = false, bFreeWine = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bArrows || !bFreeWine || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");
		if (!bFreeWine)
			bFreeWine = set.TSResearch("Free Wine");
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

//hero + barrack level 1
{
	bool bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bBarrack1)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
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

//25 hastati + 25 archers
{
	int nCount, nHastati = 25, nArchers = 25;
	str supportCmd1 = "RAddPop", supportCmd2 = "buyfoodforgold";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (olHastati.count < nHastati || olArchers.count < nArchers)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olHastati.count < nHastati) {
			nCount = nHastati - olHastati.count;
			olHastati.AddList(set.TSRecruitArmy("RHastatus", nCount));
		}
		if (olArchers.count < nArchers) {
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("RArcher", nCount));
		}
		if (set.CanAfford(supportCmd1))
			set.TSResearch(supportCmd1);
		if (set.CanAfford(supportCmd2))
			set.TSResearch(supportCmd2);
		olHastati.SetCommand("enter", set.GetCentralBuilding());
		olArchers.SetCommand("enter", set.GetCentralBuilding());
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
		olHastati.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		Sleep(5000);
	}

olHastati.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olHastati, false);
SetNoAIFlag(olArchers, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);