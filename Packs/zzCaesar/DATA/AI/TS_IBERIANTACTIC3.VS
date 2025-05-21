//void, Settlement set

//plan: focus on a functional group of elite guards supported by archers, take veteran guild to make them even stronger

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olEliteGuards, olArchers, olEnchantresses;
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

//hero + axes + 2 enchantresses + 3 exploring militiamen
{
	bool bAxes = false;
	int nCount, nEnchantresses = 2, nExploringUnits = 3, i, gold, food;
	str cmd = "trainIMilitiaman";
	point ptDummy;
	Obj objDummy;
	Barrack barrack;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bAxes || olEnchantresses.count < nEnchantresses || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		else {
			hero.SetNoAIFlag(true);
			hero.SetCommand("move", ptTeaching);
			hero.AddCommand(false, "stand_position");
		}
		if (!bAxes)
			bAxes = set.TSResearch("Battleaxes");
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

//tournaments + barrack level 1
{
	bool bBarrack1 = false, bTournaments = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || !bTournaments)) {
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bTournaments)
			bTournaments = set.TSResearch("Tournaments");
		Sleep(4100 + rand(15) * 100);
	}
}

//veteran guild + 10 archers + 10 elite guards (archers are recruited first to make sure that veteran guild is completed before elite guards spawn)
{
	bool bVeteranGuild = false;
	int nCount, nArchers = 10, nGuards = 10;
	str supportCmd = "IAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bVeteranGuild || olArchers.count < nArchers || olEliteGuards.count < nGuards)) {
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
		if (!bVeteranGuild)
			bVeteranGuild = set.TSResearch("Veteran's guild");
		if (bVeteranGuild) {
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("IArcher", nCount));
			}
			if (olEliteGuards.count < nGuards) {
				nCount = nGuards - olEliteGuards.count;
				olEliteGuards.AddList(set.TSRecruitArmy("IEliteGuard", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olEliteGuards.SetCommand("enter", set.GetCentralBuilding());
		olArchers.SetCommand("enter", set.GetCentralBuilding());
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
		olEliteGuards.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		Sleep(5000);
		//enchantresses remain in the fortress to train other units
	}

olEliteGuards.ClearDead();
olArchers.ClearDead();
olEnchantresses.ClearDead();
SetNoAIFlag(olEliteGuards, false);
SetNoAIFlag(olArchers, false);
SetNoAIFlag(olEnchantresses, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);