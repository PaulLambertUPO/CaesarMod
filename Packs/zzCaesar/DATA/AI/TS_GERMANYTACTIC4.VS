//void, Settlement set

//plan: focus on some basic units whose only role is to support agile and powerful valkyries, take also learning to improve their level and power dramatically

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olValkyries, olSwordsmen, olArchers;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkills[2] = hsAssault;
aSkillLevels[0] = 6;
aSkillLevels[1] = 4;
aSkillLevels[2] = 4;

//hero + 3 exploring swordsmen
{
	int nExploringUnits = 3, i, gold, food;
	str cmd = "trainTSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
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

//legendary valkyries + food tax
{
	bool bLegendaryValkyries = false, bFoodTax = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bLegendaryValkyries || !bFoodTax)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bLegendaryValkyries)
			bLegendaryValkyries = set.TSResearch("Legendary Valkyries");
		if (!bFoodTax)
			bFoodTax = set.TSResearch("TFoodTax");
		Sleep(4100 + rand(15) * 100);
	}
}

//10 valkyries + 15 swordsmen + 10 archers
{
	int nCount, nValkyries = 10, nSwordsmen = 15, nArchers = 10;
	str supportCmd = "buyfoodforgold";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (olValkyries.count < nValkyries || olSwordsmen.count < nSwordsmen || olArchers.count < nArchers)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olValkyries.count < nValkyries) {
			nCount = nValkyries - olValkyries.count;
			olValkyries.AddList(set.TSArenaRecruit(nCount));
		}
		if (olSwordsmen.count < nSwordsmen) {
			nCount = nSwordsmen - olSwordsmen.count;
			olSwordsmen.AddList(set.TSRecruitArmy("TSwordsman", nCount));
		}
		if (olArchers.count < nArchers) {
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("TArcher", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olValkyries.SetCommand("enter", set.GetCentralBuilding());
		olSwordsmen.SetCommand("enter", set.GetCentralBuilding());
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
		olValkyries.SetCommand("attach", hero);
		olSwordsmen.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olValkyries.ClearDead();
olSwordsmen.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olValkyries, false);
SetNoAIFlag(olSwordsmen, false);
SetNoAIFlag(olArchers, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);