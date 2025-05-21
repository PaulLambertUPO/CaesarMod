//void, Settlement set

//plan: focus on a fast group of Teuton cavalry with high damage that can quickly take map advantadge

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olTeutonRiders;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bHorseshoes || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Horseshoes production");
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

//fights + barrack level 1
{
	bool bFights = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bFights || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bFights)
			bFights = set.TSResearch("TFights");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//learning + grain trade
{
	bool bLearning = false, bGrainTrade = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bLearning || !bGrainTrade)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bLearning)
			bLearning = set.TSResearch("Learning");
		if (!bGrainTrade)
			bGrainTrade = set.TSResearch("TGrainTrade");
		Sleep(4100 + rand(15) * 100);
	}
}

//barbaric tales + horseshoes
{
	bool bBarbaricTales = false, bHorseshoes = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarbaricTales || !bHorseshoes)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarbaricTales)
			bBarbaricTales = set.TSResearch("Barbaric Tales");
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Horseshoes production");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 Teuton riders
{
	int nCount, nTeutonRiders = 20;
	str supportCmd = "buyfoodforgold";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && olTeutonRiders.count < nTeutonRiders) {
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
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		hero.SetCommand("enter", set.GetCentralBuilding());
		hero.SetNoAIFlag(false);
		olTeutonRiders.SetCommand("attach", hero);
		Sleep(5000);
	}

olTeutonRiders.ClearDead();
SetNoAIFlag(olTeutonRiders, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);