//void, Settlement set

//plan: focus on a devastating group of macemen supported by a useful food economy

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olMacemen;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkills[2] = hsAssault;
aSkillLevels[0] = 5;
aSkillLevels[1] = 5;
aSkillLevels[2] = 5;

//hero + maces + 3 exploring swordsmen
{
	int nExploringUnits = 3, i, gold, food;
	bool bMaces = false;
	str cmd = "trainTSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bMaces || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bMaces)
			bMaces = set.TSResearch("Mace production");
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

//attack focus + food sale
{
	bool bAttackFocus = false, bFoodSale = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bAttackFocus || !bFoodSale)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bAttackFocus)
			bAttackFocus = set.TSResearch("Attack focus");
		if (!bFoodSale)
			bFoodSale = set.TSResearch("Food sale");
		Sleep(4100 + rand(15) * 100);
	}
}

//food tax + maces
{
	bool bFoodTax = false, bMaces = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bFoodTax || !bMaces)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bFoodTax)
			bFoodTax = set.TSResearch("TFoodTax");
		if (!bMaces)
			bMaces = set.TSResearch("Mace production");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 macemen
{
	int nCount, nMacemen = 20;
	str supportCmd = "buyfoodforgold";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && olMacemen.count < nMacemen) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olMacemen.count < nMacemen) {
			nCount = nMacemen - olMacemen.count;
			olMacemen.AddList(set.TSRecruitArmy("TMaceman", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olMacemen.SetCommand("enter", set.GetCentralBuilding());
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
		olMacemen.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olMacemen.ClearDead();
SetNoAIFlag(olMacemen, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);