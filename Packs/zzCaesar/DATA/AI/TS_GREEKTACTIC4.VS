//void, Settlement set

//plan: focus on epic heroes by taking military preparation

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olPeltasts, olArchers, olPriests;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsWisdom;
aSkills[1] = hsTeamDefense;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//olympic games + 2 exploring peltasts
{
	int nExploringUnits = 2, i, j, min, gold, food;
	bool bOlympicGames = false, first_time = true;
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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bOlympicGames || i < nExploringUnits)) {
		if (!bOlympicGames)
			bOlympicGames = set.TSResearch("Olympic Games");
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
}

//spartan training + barrack level 1
{
	bool bSpartanTraining = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bSpartanTraining || !bBarrack1)) {
		if (!bSpartanTraining)
			bSpartanTraining = set.TSResearch("Spartan Training");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//military preparation + arrows
{
	bool bMilitaryPreparation = false, bArrows = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bMilitaryPreparation || !bArrows)) {
		if (!bMilitaryPreparation)
			bMilitaryPreparation = set.TSResearch("Military Preparation");
		if (!bArrows)
			bArrows = set.TSResearch("Greek Archers");
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + 15 peltasts + 10 toxotai + 5 priests
{
	bool bBarrack1 = false;
	int nCount, nPeltasts = 15, nArchers = 10, nPriests = 5;
	str supportCmd = "HAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || olPeltasts.count < nPeltasts || olPriests.count < nPriests)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		else {
			if (!bHeroScript) {
				Obj objDummy;
				ObjList ol;
				ol.Add(hero);
				hero.KillCommand();
				hero.TSAdvHeroSkills(aSkills, aSkillLevels);
				heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
				bHeroScript = true;
			}
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
			if (olPeltasts.count < nPeltasts) {
				nCount = nPeltasts - olPeltasts.count;
				olPeltasts.AddList(set.TSRecruitArmy("HPeltast", nCount));
			}
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("HToxotes", nCount));
			}
			if (olPriests.count < nPriests) {
				nCount = nPriests - olPriests.count;
				olPriests.AddList(set.TSTempleRecruit(nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olPeltasts.SetCommand("enter", set.GetCentralBuilding());
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
		olPeltasts.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		olPriests.SetCommand("attach", hero);
		Sleep(5000);
	}

olPeltasts.ClearDead();
olArchers.ClearDead();
olPriests.ClearDead();
SetNoAIFlag(olPeltasts, false);
SetNoAIFlag(olArchers, false);
SetNoAIFlag(olPriests, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);