//void, Settlement set

//plan: focus on a lethal combination of hastati and archers, take military academy to give a huge boost to hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHastati, olArchers;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 8;
aSkillLevels[1] = 4;

Sleep(500);//give some time to the settlement to register the chosen Rome before researching upgrades

//gladiator shows + arrows + free wine + 2 exploring hastati
{
	int nExploringUnits = 2, i, gold, food;
	bool bGladiatorShows = false, bArrows = false, bFreeWine = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bArrows || !bFreeWine || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows2");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");
		if (!bFreeWine)
			bFreeWine = set.TSResearch("Free Wine");
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
}

//military academy + barrack level 1
{
	bool bMilitaryAcademy = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bMilitaryAcademy || !bBarrack1)) {
		if (!bMilitaryAcademy)
			bMilitaryAcademy = set.TSResearch("Military Academy");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + 20 hastati + 20 archers
{
	int nCount, nHastati = 20, nArchers = 20;
	str supportCmd = "RAddPop";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || olHastati.count < nHastati || olArchers.count < nArchers)) {
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
			if (olHastati.count < nHastati) {
				nCount = nHastati - olHastati.count;
				olHastati.AddList(set.TSRecruitArmy("RHastatus", nCount));
			}
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("RArcher", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
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
		int i, attached;
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		hero.SetCommand("enter", set.GetCentralBuilding());
		hero.SetNoAIFlag(false);
		olHastati.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olHastati.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olHastati, false);
SetNoAIFlag(olArchers, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);