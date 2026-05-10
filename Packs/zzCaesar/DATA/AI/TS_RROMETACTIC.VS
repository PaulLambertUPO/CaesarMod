//void, Settlement set

//plan: focus on a lethal combination of hastati and archers, take gladiator shows to improve hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHastati, olArchers;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

Sleep(500);//give some time to the settlement to register the chosen Rome before researching upgrades

//gladiator shows + arrows + free wine + 3 exploring hastati
{
	int nExploringUnits = 3, i, gold, food;
	bool bGladiatorShows = false, bArrows = false, bFreeWine = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bArrows || !bFreeWine || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows");
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

//hero + barrack level 1
{
	bool bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bBarrack1)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
	if (hero.IsAlive) {
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
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (olHastati.count < nHastati || olArchers.count < nArchers)) {
		if (hero.IsAlive)
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