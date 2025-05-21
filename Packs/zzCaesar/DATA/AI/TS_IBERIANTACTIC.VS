//void, Settlement set

//plan: focus on a sturdy group of defenders supported by archers, meanwhile take ancestral knowledge to improve hero and troops level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olDefenders, olArchers, olEnchantresses;
int AIPlayer, heroScriptId;
bool bHeroScript = false;
point ptTeaching;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsHealing;
aSkills[1] = hsVigor;
aSkills[2] = hsTeamDefense;
aSkillLevels[0] = 5;
aSkillLevels[1] = 5;
aSkillLevels[2] = 4;

ptTeaching = set.GetCentralBuilding().pos;
ptTeaching.SetLen(ptTeaching.Len + 220);

//hero + spears + 2 enchantresses + 3 exploring militiamen
{
	bool bSpears = false;
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

//barrack level 1 + 6 enchantresses
{
	bool bBarrack1 = false;
	int nCount, nEnchantresses = 8;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || olEnchantresses.count < nEnchantresses)) {
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

//code of valor + ancestral knowledge + 20 defenders + 15 archers
{
	bool bCodeValor = false, bAncestralKnowledge = false;
	int nCount, nDefenders = 20, nArchers = 15;
	str supportCmd = "IAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bCodeValor || !bAncestralKnowledge || olDefenders.count < nDefenders || olArchers.count < nArchers)) {
		if (hero.IsValid) {
			if (!bHeroScript)
				if (hero.inherentlevel >= 8) {
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
		if (!bCodeValor)
			bCodeValor = set.TSResearch("Code of Valor");
		if (bCodeValor)
			if (!bAncestralKnowledge)
				bAncestralKnowledge = set.TSResearch("Ancestral Knowledge");
		if (bAncestralKnowledge) {
			if (olDefenders.count < nDefenders) {
				nCount = nDefenders - olDefenders.count;
				olDefenders.AddList(set.TSRecruitArmy("IDefender", nCount));
			}
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("IArcher", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olDefenders.SetCommand("enter", set.GetCentralBuilding());
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
		olArchers.SetCommand("attach", hero);
		Sleep(5000);
		//enchantresses remain in the fortress to train other units
	}

olDefenders.ClearDead();
olArchers.ClearDead();
olEnchantresses.ClearDead();
SetNoAIFlag(olDefenders, false);
SetNoAIFlag(olArchers, false);
SetNoAIFlag(olEnchantresses, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);