//void, Settlement set

//plan: focus on a swift group of scouts, take import horses to improve them and take military academy to give a huge boost to hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olScouts;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsTeamDefense;
aSkillLevels[0] = 8;
aSkillLevels[1] = 4;

//gladiator shows + horseshoes + free wine + 2 exploring hastati
{
	int nExploringUnits = 2, i, gold, food;
	bool bGladiatorShows = false, bHorseshoes = false, bFreeWine = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bHorseshoes || !bFreeWine || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows2");
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

//military academy + arrows
{
	bool bMilitaryAcademy = false, bArrows = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bMilitaryAcademy || !bArrows)) {
		if (!bMilitaryAcademy)
			bMilitaryAcademy = set.TSResearch("Military Academy");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");//archers are researched in order to be already recruitable when the script ends
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + import horses + barrack level 1 + 20 scouts
{
	bool bImportHorses = false, bBarrack1 = false;
	int nCount, nScouts = 20;
	str supportCmd = "RAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bImportHorses || !bBarrack1 || olScouts.count < nScouts)) {
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
			if (bImportHorses)
				if (bBarrack1)
					if (olScouts.count < nScouts) {//try to recruit scouts only after import horses is completed
						nCount = nScouts - olScouts.count;
						olScouts.AddList(set.TSRecruitArmy("RScout", nCount));
					}
		}
		if (!bImportHorses)
			bImportHorses = set.TSResearch("Import horses");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
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