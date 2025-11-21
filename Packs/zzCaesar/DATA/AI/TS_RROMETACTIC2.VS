//void, Settlement set

//plan: focus on an impavid group of gladiators supported by priests, use training to improve them

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olGladiators, olPriests;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

Sleep(500);//give some time to the settlement to register the chosen Rome before researching upgrades

//gladiator shows + 3 exploring hastati
{
	int nExploringUnits = 3, i, gold, food;
	bool bGladiatorShows = false;
	str cmd = "trainRHastatus";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("RGladiator Shows");
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
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bBarrack1)) {
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

//training 1 + arrows
{
	bool bTraining1 = false, bArrows = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bTraining1 || !bArrows)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bTraining1)
			bTraining1 = set.TSResearch("Rome Training 1");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");//archers are researched in order to be already recruitable when the script ends
		Sleep(4100 + rand(15) * 100);
	}
}

//training 2 + 20 gladiators + 10 priests
{
	bool bTraining2 = false;
	int nCount, nGladiators = 20, nPriests = 10;
	str supportCmd1 = "RAddPop", supportCmd2 = "buyfoodforgold";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bTraining2 || olGladiators.count < nGladiators || olPriests.count < nPriests)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bTraining2)
			bTraining2 = set.TSResearch("Rome Training 2");
		if (bTraining2)
			if (olGladiators.count < nGladiators) {
				nCount = nGladiators - olGladiators.count;
				olGladiators.AddList(set.TSRecruitArmy("RGladiator", nCount));
			}
		if (olPriests.count < nPriests) {
			nCount = nPriests - olPriests.count;
			olPriests.AddList(set.TSTempleRecruit(nCount));
		}
		if (set.CanAfford(supportCmd1))
			set.TSResearch(supportCmd1);
		if (set.CanAfford(supportCmd2))
			set.TSResearch(supportCmd2);
		olGladiators.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
}

//start training
{
	point ptTraining;
	ptTraining = set.GetCentralBuilding().pos;
	ptTraining.SetLen(ptTraining.Len + 220);
	if (bHeroScript)
		AIBreakScript(heroScriptId);
	if (hero.IsValid)
		if (hero.IsAlive) {
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
			hero.SetCommand("move", ptTraining);
			hero.AddCommand(false, "train");
			Sleep(10000);//wait for the hero to come back so that he might train with the other units
		}
	olGladiators.SetCommand("move", ptTraining);
	olGladiators.AddCommand(false, "train");
	olPriests.SetCommand("heal", ptTraining);
	Sleep(35000);
	olGladiators.SetCommand("train");
	if (hero.IsValid)
		if (hero.IsAlive) {
			hero.SetCommand("move", ptTraining);
			hero.AddCommand(false, "train");
		}
	Sleep(30000);
	if (set.player == aiPlayer)
		set.Research("autotrain_start");
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
		olGladiators.SetCommand("attach", hero);
		olPriests.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olGladiators.ClearDead();
olPriests.ClearDead();
SetNoAIFlag(olGladiators, false);
SetNoAIFlag(olPriests, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);