//void, Settlement set

//plan: focus on a quick combination of scouts, take gladiator shows to improve hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olScouts;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsTeamDefense;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

//gladiator shows + horseshoes + free wine + 3 exploring hastati
{
	int nExploringUnits = 3, i, gold, food;
	bool bGladiatorShows = false, bHorseshoes = false, bFreeWine = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bHorseshoes || !bFreeWine || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows");
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Roman Scout");
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

//30 scouts
{
	int nCount, nScouts = 30;
	str supportCmd1 = "RAddPop", supportCmd2 = "buyfoodforgold";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && olScouts.count < nScouts) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olScouts.count < nScouts) {
			nCount = nScouts - olScouts.count;
			olScouts.AddList(set.TSRecruitArmy("RScout", nCount));
		}
		if (set.CanAfford(supportCmd1))
			set.TSResearch(supportCmd1);
		if (set.CanAfford(supportCmd2))
			set.TSResearch(supportCmd2);
		olScouts.SetCommand("enter", set.GetCentralBuilding());
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
		olScouts.SetCommand("attach", hero);
		Sleep(5000);
	}

olScouts.ClearDead();
SetNoAIFlag(olScouts, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);