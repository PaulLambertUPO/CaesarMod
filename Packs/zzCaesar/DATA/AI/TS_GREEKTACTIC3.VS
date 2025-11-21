//void, Settlement set

//plan: focus on an unscratchable group of hypaspists, take olympic games to improve their level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHypaspists;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamDefense;
aSkillLevels[0] = 10;

//hero + royal armor + 2 exploring peltasts
{
	int nExploringUnits = 2, i, j, min, gold, food;
	bool bRoyalArmor = false, first_time = true;
	str cmd = "trainHPeltast";
	Barrack barrack;
	Building b;
	point ptDummy;
	Obj objDummy;
	ObjList buildings;
	buildings = set.Buildings;
	for (j = 0; j < buildings.count; j += 1) {
		b = buildings[j];
		if (b.IsHeirOf("HBarracks"))//using IsHeirOf is better than a direct class check because it manages winter variants
			if (!b.IsBroken)
				if (first_time) {
					first_time = false;
					min = b.CmdCount;
					barrack = b;
				}
				else if (b.CmdCount < min) {
					min = b.CmdCount;
					barrack = b;
				}
	}
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bRoyalArmor || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bRoyalArmor)
			bRoyalArmor = set.TSResearch("Greek Royal Armor");
		if (i < nExploringUnits) {
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
		Obj objDummy;
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//olympic games + arrows
{
	bool bOlympicGames = false, bArrows = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bOlympicGames || !bArrows)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bOlympicGames)
			bOlympicGames = set.TSResearch("Olympic Games");
		if (!bArrows)
			bArrows = set.TSResearch("Greek Archers");//archers are researched in order to be already recruitable when the script ends
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 1 + 20 hypaspists
{
	bool bBarrack1 = false;
	int nCount, nHypaspists = 20;
	str supportCmd = "HAddPop";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || olHypaspists.count < nHypaspists)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (bBarrack1)
			if(olHypaspists.count < nHypaspists) {
				nCount = nHypaspists - olHypaspists.count;
				olHypaspists.AddList(set.TSRecruitArmy("HHypaspista", nCount));
			}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olHypaspists.SetCommand("enter", set.GetCentralBuilding());
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
		olHypaspists.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olHypaspists.ClearDead();
SetNoAIFlag(olHypaspists, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);