//void, Settlement set

//plan: focus on an unscratchable group of hypaspists, take olympic games to improve their level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHypaspists;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamDefense;
aSkillLevels[0] = 10;

//hero + royal armor + 2 exploring peltasts
{
	int nExploringUnits = 2, i, j, min, gold, food;
	bool bRoyalArmor = false, first_time = true;
	str cmd = "trainHPeltast";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	ObjList buildings;
	buildings = set.Buildings();
	for (j = 0; j < buildings.count; j += 1)
		if (buildings[j].class == "HBarracks")
			if (first_time || buildings[j].CmdCount < min) {
				first_time = false;
				min = buildings[j].CmdCount;
				barrack = buildings[j];
			}
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bRoyalArmor || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bRoyalArmor)
			bRoyalArmor = set.TSResearch("Greek Royal Armor");
		if (i < nExploringUnits) {
			if (barrack.IsValid)
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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bOlympicGames || !bArrows)) {
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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || olHypaspists.count < nHypaspists)) {
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
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		hero.SetCommand("enter", set.GetCentralBuilding());
		hero.SetNoAIFlag(false);
		olHypaspists.SetCommand("attach", hero);
		Sleep(5000);
	}

olHypaspists.ClearDead();
SetNoAIFlag(olHypaspists, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);