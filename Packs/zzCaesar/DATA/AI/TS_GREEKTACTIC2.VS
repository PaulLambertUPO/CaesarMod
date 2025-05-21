//void, Settlement set

//plan: focus on a relentless group of hetairoi, use spartan training to improve them and the hero

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olCataphracts, olPriests;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsBattleCry;
aSkillLevels[0] = 10;

//hero + horse armor + 2 exploring peltasts
{
	int nExploringUnits = 2, i, j, min, gold, food;
	bool bHorseArmor = false, first_time = true;
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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bHorseArmor || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bHorseArmor)
			bHorseArmor = set.TSResearch("Greek Horse Armor");
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

//spartan training + barrack level 1
{
	bool bSpartanTraining = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bSpartanTraining || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bSpartanTraining)
			bSpartanTraining = set.TSResearch("Spartan Training");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 hetairoi + 5 priests
{
	int nCount, nCataphracts = 20, nPriests = 5;
	str supportCmd = "HAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (olCataphracts.count < nCataphracts || olPriests.count < nPriests)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olCataphracts.count < nCataphracts) {
			nCount = nCataphracts - olCataphracts.count;
			olCataphracts.AddList(set.TSRecruitArmy("HCataphract", nCount));
		}
		if (olPriests.count < nPriests) {
			nCount = nPriests - olPriests.count;
			olPriests.AddList(set.TSTempleRecruit(nCount));
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olCataphracts.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
}

//start training
{
	point ptTraining;
	ptTraining = set.GetCentralBuilding().pos;
	ptTraining.SetLen(ptTraining.Len + 220);
	if (bHeroScript)
		AIBreakScript(heroScriptId);
	if (hero.IsValid)
		if (hero.IsAlive) {
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
			hero.SetCommand("move", ptTraining);
			hero.AddCommand(false, "train");
			Sleep(10000);//wait for the hero to come back so that he might train with the other units
		}
	olCataphracts.SetCommand("move", ptTraining);
	olCataphracts.AddCommand(false, "train");
	olPriests.SetCommand("heal", ptTraining);
	Sleep(35000);
	olCataphracts.SetCommand("train");
	if (hero.IsValid)
		if (hero.IsAlive) {
			hero.SetCommand("move", ptTraining);
			hero.AddCommand(false, "train");
		}
	Sleep(30000);
	if (set.player == AIPlayer)
		set.Research("autotrain_start");
}

//give control back to AI
if (hero.IsValid)
	if (hero.IsAlive) {
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		hero.SetCommand("enter", set.GetCentralBuilding());
		hero.SetNoAIFlag(false);
		olCataphracts.SetCommand("attach", hero);
		Sleep(5000);
		//priests would slow down the cavalry army, it's better to keep them in the stronghold to help in the training of future units
	}

olCataphracts.ClearDead();
olPriests.ClearDead();
SetNoAIFlag(olCataphracts, false);
SetNoAIFlag(olPriests, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);