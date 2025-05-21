//void, Settlement set

//plan: focus on a big and powerful group of axemen, take bear teeth and belts of might to make them even stronger

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olAxemen;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsBattleCry;
aSkillLevels[0] = 10;

//hero + axes + free beer + 4 exploring archers
{
	int nExploringUnits = 4, i, gold, food;
	bool bAxes1 = false, bFreeBeer = false;
	str cmd = "trainGArcher";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bAxes1 || !bFreeBeer || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bAxes1)
			bAxes1 = set.TSResearch("Gaul Axeman");
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

//iron axes + barrack level 1 + bear teeth
{
	bool bAxes2 = false, bBarrack1 = false, bBearTeeth = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bAxes2 || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bAxes2)
			bAxes2 = set.TSResearch("Gaul Iron Axes");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bBearTeeth)
			bBearTeeth = set.TSResearch("Nordic trade routes");
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 2 + might belts
{
	bool bBarrack2 = false, bMightBelts = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || !bMightBelts)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (!bMightBelts)
			bMightBelts = set.TSResearch("Belts of Might");
		Sleep(4100 + rand(15) * 100);
	}
}
olAxemen.ClearDead();

//25 axemen
{
	int nCount, nAxemen = 25;
	str supportCmd = "GAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && olAxemen.count < nAxemen) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olAxemen.count < nAxemen) {
			nCount = nAxemen - olAxemen.count;
			olAxemen.AddList(set.TSRecruitArmy("GAxeman", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olAxemen.SetCommand("enter", set.GetCentralBuilding());
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
		olAxemen.SetCommand("attach", hero);
		Sleep(5000);
	}

olAxemen.ClearDead();
SetNoAIFlag(olAxemen, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);