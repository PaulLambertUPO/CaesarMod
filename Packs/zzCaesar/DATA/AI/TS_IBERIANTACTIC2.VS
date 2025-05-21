//void, Settlement set

//plan: focus on a powerful combination of defenders and slingers, meanwhile sell food in order to support economy

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olDefenders, olSlingers, olEnchantresses;
int AIPlayer, heroScriptId;
bool bHeroScript = false;
point ptTeaching;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsHealing;
aSkills[1] = hsTeamDefense;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

ptTeaching = set.GetCentralBuilding().pos;
ptTeaching.SetLen(ptTeaching.Len + 220);

//hero + spears + free drinks + 2 enchantresses + 3 exploring militiamen
{
	bool bSpears = false, bFreeDrinks = false;
	int nCount, nEnchantresses = 2, nExploringUnits = 3, i, gold, food;
	str cmd = "trainIMilitiaman";
	point ptDummy;
	Obj objDummy;
	Barrack barrack;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bSpears || olEnchantresses.count < nEnchantresses || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		else {
			hero.SetNoAIFlag(true);
			hero.SetCommand("move", ptTeaching);
			hero.AddCommand(false, "stand_position");
		}
		if (!bSpears)
			bSpears = set.TSResearch("Spears");
		if (!bFreeDrinks)
			bFreeDrinks = set.TSResearch("Free Drinks");
		if (olEnchantresses.count < nEnchantresses) {
			nCount = nEnchantresses - olEnchantresses.count;
			olEnchantresses.AddList(set.TSTempleRecruit(nCount));
		}
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
}

//slings + barrack level 1 + 3 enchantresses
{
	bool bSlings = false, bBarrack1 = false;
	int nCount, nEnchantresses = 5;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bSlings || !bBarrack1 || olEnchantresses.count < nEnchantresses)) {
		if (!bSlings)
			bSlings = set.TSResearch("Slings");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (olEnchantresses.count < nEnchantresses) {
			nCount = nEnchantresses - olEnchantresses.count;
			olEnchantresses.AddList(set.TSTempleRecruit(nCount));
		}
		Sleep(4100 + rand(15) * 100);
	}
}

//start teaching
{
	olEnchantresses.SetCommand("move", ptTeaching);
	olEnchantresses.AddCommand(false, "teach", hero);
	if (set.player == AIPlayer)
		set.Research("autotrain_start");
	Sleep(4100 + rand(15) * 100);
}

//barrack level 2 + 20 defenders + 20 slingers
{
	bool bBarrack2 = false;
	int nCount, nDefenders = 20, nSlingers = 20;
	str supportCmd = "Sell food";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olDefenders.count < nDefenders || olSlingers.count < nSlingers)) {
		if (hero.IsValid) {
			if (!bHeroScript)
				if (hero.inherentlevel >= 4) {
					Obj objDummy;
					ObjList ol;
					ol.Add(hero);
					hero.KillCommand();
					hero.TSAdvHeroSkills(aSkills, aSkillLevels);
					heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
					bHeroScript = true;
				}
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		}
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2) {
			if (olDefenders.count < nDefenders) {
				nCount = nDefenders - olDefenders.count;
				olDefenders.AddList(set.TSRecruitArmy("IDefender", nCount));
			}
			if (olSlingers.count < nSlingers) {
				nCount = nSlingers - olSlingers.count;
				olSlingers.AddList(set.TSRecruitArmy("ISlinger", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olDefenders.SetCommand("enter", set.GetCentralBuilding());
		olSlingers.SetCommand("enter", set.GetCentralBuilding());
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
		olDefenders.SetCommand("attach", hero);
		olSlingers.SetCommand("attach", hero);
		Sleep(5000);
		//enchantresses remain in the fortress to train other units
	}

olDefenders.ClearDead();
olSlingers.ClearDead();
olEnchantresses.ClearDead();
SetNoAIFlag(olDefenders, false);
SetNoAIFlag(olSlingers, false);
SetNoAIFlag(olEnchantresses, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);