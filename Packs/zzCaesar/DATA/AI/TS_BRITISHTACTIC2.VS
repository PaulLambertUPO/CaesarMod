//void, Settlement set

//plan: focus on a solid combination of shield bearers and archers or javelineers depending on gambling, take also gambler day

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olShieldBearers, olRangedUnits;
str rangedUnitClass;
int AIPlayer, heroScriptId;
bool bHeroScript = false, bLuckyGambling;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsAssault;
aSkills[1] = hsEuphoria;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//hero + gambling + large shields + 4 exploring swordsmen
{
	int nExploringUnits = 4, i, gold, food;
	bool bGambling = false, bLargeShields = false;
	str cmd = "trainBSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bGambling || !bLargeShields || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bGambling)
			bGambling = set.TSResearch("Gambling");
		if (!bLargeShields)
			bLargeShields = set.TSResearch("Britain Large Shields");
		if (i < nExploringUnits) {
			barrack = set.BestBarrack(5);
			if (barrack.IsValid)
				if (GetCmdCost(cmd, gold, food)) {
					set.SpentGoldOnArmy(gold + food / 2);
					barrack.ExecCmd(cmd, ptDummy, objDummy, false);
				}
			i += 1;
		}
		Sleep(4100 + rand(15) * 100);//this interval combined with hero recruitment time makes sure that we can safely check settlement lucky environment variable
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

bLuckyGambling = EnvReadString(set, "LuckyGambling") == "yes";
if (bLuckyGambling)
	rangedUnitClass = "BJavelineer";
else
	rangedUnitClass = "BBowman";

//gambler day + barrack level 1 + lucky javelins
{
	bool bGamblerDay = false, bBarrack1 = false, bJavelins = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGamblerDay || !bBarrack1 || !bJavelins)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bGamblerDay)
			bGamblerDay = set.TSResearch("Gambler's Day");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bJavelins)
			if (!bLuckyGambling)
				bJavelins = true;
			else
				bJavelins = set.TSResearch("Britain Javelins");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 shield bearers + 20 archers or javelineers + lucky barrack level 2
{
	int nCount, nShieldBearers = 20, nRangedUnits = 20;
	bool bBarrack2 = false;
	str supportCmd = "BAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olShieldBearers.count < nShieldBearers || olRangedUnits.count < nRangedUnits)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			if (!bLuckyGambling)
				bBarrack2 = true;
			else
				bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2) {
			if (olShieldBearers.count < nShieldBearers) {
				nCount = nShieldBearers - olShieldBearers.count;
				olShieldBearers.AddList(set.TSRecruitArmy("BShieldBearer", nCount));
			}
			if (olRangedUnits.count < nRangedUnits) {
				nCount = nRangedUnits - olRangedUnits.count;
				olRangedUnits.AddList(set.TSRecruitArmy(rangedUnitClass, nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olShieldBearers.SetCommand("enter", set.GetCentralBuilding());
		olRangedUnits.SetCommand("enter", set.GetCentralBuilding());
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
		olShieldBearers.SetCommand("attach", hero);
		olRangedUnits.SetCommand("attach", hero);
		Sleep(5000);
	}

olShieldBearers.ClearDead();
olRangedUnits.ClearDead();
SetNoAIFlag(olShieldBearers, false);
SetNoAIFlag(olRangedUnits, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);