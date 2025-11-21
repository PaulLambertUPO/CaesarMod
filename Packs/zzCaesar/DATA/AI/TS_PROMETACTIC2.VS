//void, Settlement set

//plan: focus on a firm group of hastati and principles, take military academy to give a huge boost to hero level

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHastati, olPrinciples;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsTeamAttack;
aSkills[1] = hsQuickMarch;
aSkillLevels[0] = 8;
aSkillLevels[1] = 4;

Sleep(500);//give some time to the settlement to register the chosen Rome before researching upgrades

//gladiator shows + pikes + 2 exploring hastati
{
	int nExploringUnits = 2, i, gold, food;
	bool bGladiatorShows = false, bPikes = false;
	str cmd = "trainRHastatusPunic";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bGladiatorShows || !bPikes || i < nExploringUnits)) {
		if (!bGladiatorShows)
			bGladiatorShows = set.TSResearch("Gladiator Shows");
		if (!bPikes)
			bPikes = set.TSResearch("Roman Principle");
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

//military academy + arrows + barrack level 1
{
	bool bMilitaryAcademy = false, bArrows = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bMilitaryAcademy || !bArrows || !bBarrack1)) {
		if (!bMilitaryAcademy)
			bMilitaryAcademy = set.TSResearch("Military Academy");
		if (!bArrows)
			bArrows = set.TSResearch("Roman Archers");//archers are researched in order to be already recruitable when the script ends
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//hero + 10 hastati + 10 principles
{
	int nCount, nHastati = 10, nPrinciples = 10;
	str supportCmd = "RAddPop";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || olHastati.count < nHastati || olPrinciples.count < nPrinciples)) {
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
			if (olHastati.count < nHastati) {
				nCount = nHastati - olHastati.count;
				olHastati.AddList(set.TSRecruitArmy("RHastatusPunic", nCount));
			}
			if (olPrinciples.count < nPrinciples) {
				nCount = nPrinciples - olPrinciples.count;
				olPrinciples.AddList(set.TSRecruitArmy("RPrinciplePunic", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olHastati.SetCommand("enter", set.GetCentralBuilding());
		olPrinciples.SetCommand("enter", set.GetCentralBuilding());
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
		olHastati.SetCommand("attach", hero);
		olPrinciples.SetCommand("attach", hero);
		attached = hero.army.count;
		for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
			Sleep(10000);
			if (hero.army.count > attached)
				break;
		}
	}

olHastati.ClearDead();
olPrinciples.ClearDead();
SetNoAIFlag(olHastati, false);
SetNoAIFlag(olPrinciples, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);