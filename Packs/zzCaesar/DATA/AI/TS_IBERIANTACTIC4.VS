//void, Settlement set

//plan: focus on an aggressive group of cavalry and take tame horses to increase their level, meanwhile sell food in order to support economy

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olCavalry, olEnchantresses;
int AIPlayer, heroScriptId;
bool bHeroScript = false;
point ptTeaching;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[1] = hsTeamDefense;
aSkills[0] = hsHealing;
aSkillLevels[0] = 6;
aSkillLevels[1] = 6;

ptTeaching = set.GetCentralBuilding().pos;
ptTeaching.SetLen(ptTeaching.Len + 220);

//hero + horseshoes + free drinks + 2 enchantresses + 3 exploring militiamen
{
	bool bHorseshoes = false, bFreeDrinks = false;
	int nCount, nEnchantresses = 2, nExploringUnits = 3, i, gold, food;
	str cmd = "trainIMilitiaman";
	point ptDummy;
	Obj objDummy;
	Barrack barrack;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bHorseshoes || olEnchantresses.count < nEnchantresses || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		else {
			hero.SetNoAIFlag(true);
			hero.SetCommand("move", ptTeaching);
			hero.AddCommand(false, "stand_position");
		}
		if (!bHorseshoes)
			bHorseshoes = set.TSResearch("Horseshoes");
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

//start teaching
{
	olEnchantresses.SetCommand("move", ptTeaching);
	olEnchantresses.AddCommand(false, "teach", hero);
	if (set.player == AIPlayer)
		set.Research("autotrain_start");
	Sleep(4100 + rand(15) * 100);
}

//barrack level 1 + tame horses
{
	bool bBarrack1 = false, bTameHorses = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || !bTameHorses)) {
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bTameHorses)
			bTameHorses = set.TSResearch("Tame horses");
		Sleep(4100 + rand(15) * 100);
	}
}

//30 cavalry
{
	int nCount, nCavalry = 30;
	str supportCmd = "Sell food";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && olCavalry.count < nCavalry) {
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
		if (olCavalry.count < nCavalry) {
			nCount = nCavalry - olCavalry.count;
			olCavalry.AddList(set.TSRecruitArmy("ICavalry", nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olCavalry.SetCommand("enter", set.GetCentralBuilding());
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
		olCavalry.SetCommand("attach", hero);
		Sleep(5000);
		//enchantresses remain in the fortress to train other units
	}

olCavalry.ClearDead();
olEnchantresses.ClearDead();
SetNoAIFlag(olCavalry, false);
SetNoAIFlag(olEnchantresses, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);