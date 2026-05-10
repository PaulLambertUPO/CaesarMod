//void, Settlement set

//plan: focus on a combination of axemen and huntresses that is able to fight any enemy regardless of level and armor

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olAxemen, olHuntresses;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkills[2] = hsAssault;
aSkillLevels[0] = 4;
aSkillLevels[1] = 4;
aSkillLevels[2] = 6;

//hero + axes + 3 exploring swordsmen
{
	int nExploringUnits = 3, i, gold, food;
	bool bAxes = false;
	str cmd = "trainTSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bAxes || i < nExploringUnits)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bAxes)
			bAxes = set.TSResearch("Axe production");
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
	if (hero.IsAlive) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//tribal fights + javelins + barrack level 1
{
	bool bTribalFights = false, bJavelins = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bTribalFights || !bJavelins || !bBarrack1)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bTribalFights)
			bTribalFights = set.TSResearch("Tribal fights");
		if (!bJavelins)
			bJavelins = set.TSResearch("Javelin production");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//attack focus + food sale
{
	bool bAttackFocus = false, bFoodSale = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bAttackFocus || !bFoodSale)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bAttackFocus)
			bAttackFocus = set.TSResearch("Attack focus");
		if (!bFoodSale)
			bFoodSale = set.TSResearch("Food sale");
		Sleep(4100 + rand(15) * 100);
	}
}

//axes + barrack level 2
{
	bool bAxes = false, bBarrack2 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bAxes || !bBarrack2)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bAxes)
			bAxes = set.TSResearch("Axe production");
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 axemen + 10 huntresses
{
	int nCount, nAxemen = 20, nHuntresses = 10;
	str supportCmd = "buyfoodforgold";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (olAxemen.count < nAxemen || olHuntresses.count < nHuntresses)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olAxemen.count < nAxemen) {
			nCount = nAxemen - olAxemen.count;
			olAxemen.AddList(set.TSRecruitArmy("TAxeman", nCount));
		}
		if (olHuntresses.count < nHuntresses) {
			nCount = nHuntresses - olHuntresses.count;
			olHuntresses.AddList(set.TSRecruitArmy("THuntress", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olAxemen.SetCommand("enter", set.GetCentralBuilding());
		olHuntresses.SetCommand("enter", set.GetCentralBuilding());
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
	olAxemen.SetCommand("attach", hero);
	olHuntresses.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
}

olAxemen.ClearDead();
olHuntresses.ClearDead();
SetNoAIFlag(olAxemen, false);
SetNoAIFlag(olHuntresses, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);