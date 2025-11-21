//void, Settlement set

//plan: focus on a fast group of Teuton cavalry with high damage that can quickly take map advantadge

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olTeutonRiders;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkills[2] = hsAssault;
aSkillLevels[0] = 4;
aSkillLevels[1] = 6;
aSkillLevels[2] = 4;

//hero + horseshoes + 3 exploring swordsmen
{
	int nExploringUnits = 3, i, gold, food;
	bool bHorseshoes = false;
	str cmd = "trainTSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bHorseshoes || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Horseshoe production");
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
	if (hero.IsValid) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//tribal fights + barrack level 1
{
	bool bTribalFights = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bTribalFights || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bTribalFights)
			bTribalFights = set.TSResearch("Tribal fights");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//learning + food sale
{
	bool bLearning = false, bFoodSale = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bLearning || !bFoodSale)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bLearning)
			bLearning = set.TSResearch("Learning");
		if (!bFoodSale)
			bFoodSale = set.TSResearch("Food sale");
		Sleep(4100 + rand(15) * 100);
	}
}

//barbaric tales + horseshoes
{
	bool bBarbaricTales = false, bHorseshoes = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarbaricTales || !bHorseshoes)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarbaricTales)
			bBarbaricTales = set.TSResearch("Barbaric Tales");
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Horseshoe production");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 Teuton riders
{
	int nCount, nTeutonRiders = 20;
	str supportCmd = "buyfoodforgold";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && olTeutonRiders.count < nTeutonRiders) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olTeutonRiders.count < nTeutonRiders) {
			nCount = nTeutonRiders - olTeutonRiders.count;
			olTeutonRiders.AddList(set.TSRecruitArmy("TTeutonRider", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olTeutonRiders.SetCommand("enter", set.GetCentralBuilding());
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
		olTeutonRiders.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olTeutonRiders.ClearDead();
SetNoAIFlag(olTeutonRiders, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);