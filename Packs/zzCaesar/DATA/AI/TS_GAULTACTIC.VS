//void, Settlement set

//plan: focus on a big and fast group of horsemen and take bear teeth to improve charge damage

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHorsemen;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsDefensiveCry;
aSkillLevels[0] = 10;

//hero + horseshoes + free beer + 4 exploring archers
{
	int nExploringUnits = 4, i, gold, food;
	bool bHorseshoes1 = false, bFreeBeer = false;
	str cmd = "trainGArcher";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bHorseshoes1 || !bFreeBeer || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bHorseshoes1)
			bHorseshoes1 = set.TSResearch("Gaul Horseman");
		if (!bFreeBeer)
			bFreeBeer = set.TSResearch("Free Beer");
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
	if (hero.IsValid) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//exceptional horseshoes + barrack level 1 + bear teeth
{
	bool bHorseshoes2 = false, bBarrack1 = false, bBearTeeth = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bHorseshoes2 || !bBarrack1 || !bBearTeeth)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bHorseshoes2)
			bHorseshoes2 = set.TSResearch("Gaul Exceptional Horseshoes");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bBearTeeth)
			bBearTeeth = set.TSResearch("Nordic trade routes");
		Sleep(4100 + rand(15) * 100);
	}
}

//30 horsemen
{
	int nCount, nHorsemen = 30;
	str supportCmd = "GAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && olHorsemen.count < nHorsemen) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olHorsemen.count < nHorsemen) {
			nCount = nHorsemen - olHorsemen.count;
			olHorsemen.AddList(set.TSRecruitArmy("GHorseman", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olHorsemen.SetCommand("enter", set.GetCentralBuilding());
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
		olHorsemen.SetCommand("attach", hero);
		Sleep(5000);
	}

olHorsemen.ClearDead();
SetNoAIFlag(olHorsemen, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);