//void, Settlement set

//plan: focus on a big group of basic units, take bear teeth and belts of might to improve them a bit, take also warrior tales to get some experience because many will die

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olSwordsmen, olArchers;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsDefensiveCry;
aSkillLevels[0] = 10;

//hero + free beer + 4 exploring archers
{
	int nExploringUnits = 4, i, gold, food;
	bool bFreeBeer = false;
	str cmd = "trainGArcher";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bFreeBeer || i < nExploringUnits)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bFreeBeer)
			bFreeBeer = set.TSResearch("Free Beer");
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

//fights + bear teeth
{
	bool bFights = false, bBearTeeth = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bFights || !bBearTeeth)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bFights)
			bFights = set.TSResearch("Fights");
		if (!bBearTeeth)
			bBearTeeth = set.TSResearch("Nordic trade routes");
		Sleep(4100 + rand(15) * 100);
	}
}

//warrior tales + belts of might + barrack level 1
{
	bool bWarriorTales = false, bMightBelts = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bWarriorTales || !bMightBelts || !bBarrack1)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bWarriorTales)
			bWarriorTales = set.TSResearch("Warrior Tales");
		if (!bMightBelts)
			bMightBelts = set.TSResearch("Belts of Might");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//30 swordsmen + 20 archers
{
	int nCount, nSwordsmen = 30, nArchers = 20;
	str supportCmd = "GAddPop";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (olSwordsmen.count < nSwordsmen || olArchers.count < nArchers)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olSwordsmen.count < nSwordsmen) {
			nCount = nSwordsmen - olSwordsmen.count;
			olSwordsmen.AddList(set.TSRecruitArmy("GSwordsman", nCount));
		}
		if (olArchers.count < nArchers) {
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("GArcher", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olSwordsmen.SetCommand("enter", set.GetCentralBuilding());
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
	olSwordsmen.SetCommand("attach", hero);
	olArchers.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
}

olSwordsmen.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olSwordsmen, false);
SetNoAIFlag(olArchers, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);