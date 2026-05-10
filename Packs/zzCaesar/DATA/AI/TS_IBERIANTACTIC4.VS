//void, Settlement set

//plan: focus on an aggressive group of cavalry and take tame horses to increase their level, meanwhile sell food in order to support economy

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olCavalry, olEnchantresses;
int aiPlayer, heroScriptId;
bool bHeroScript = false;
point ptTeaching;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

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
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bHorseshoes || olEnchantresses.count < nEnchantresses || i < nExploringUnits)) {
		if (hero.IsDead)
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

//start teaching
{
	olEnchantresses.SetCommand("move", ptTeaching);
	olEnchantresses.AddCommand(false, "teach", hero);
	if (set.player == aiPlayer)
		set.Research("autotrain_start");
	Sleep(4100 + rand(15) * 100);
}

//barrack level 1 + tame horses
{
	bool bBarrack1 = false, bTameHorses = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || !bTameHorses)) {
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bTameHorses)
			bTameHorses = set.TSResearch("Tame horses");
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 2 + 30 cavalry
{
	int nCount, nCavalry = 30;
	bool bBarrack2 = false;
	str supportCmd = "Sell food";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olCavalry.count < nCavalry)) {
		if (hero.IsAlive) {
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
		if (bBarrack2)
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
if (hero.IsAlive) {
	int i, attached;
	hero.TSAdvHeroSkills(aSkills, aSkillLevels);
	hero.SetCommand("enter", set.GetCentralBuilding());
	hero.SetNoAIFlag(false);
	olCavalry.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
	//enchantresses remain in the fortress to train other units
}

olCavalry.ClearDead();
olEnchantresses.ClearDead();
SetNoAIFlag(olCavalry, false);
SetNoAIFlag(olEnchantresses, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);