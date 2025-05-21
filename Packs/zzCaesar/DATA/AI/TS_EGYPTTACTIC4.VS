//void, Settlement set

//plan: focus on a deadly group of Horus warriors, imbued with divine powers

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olHorusWarriors, olSwordsmen, olArchers;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsQuickMarch;
aSkills[1] = hsHealing;
aSkillLevels[0] = 4;
aSkillLevels[1] = 8;

//hero + grain trade + 3 exploring swordsmen
{
	int nExploringUnits = 3, i, gold, food;
	bool bGrainTrade = false;
	str cmd = "trainESwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bGrainTrade || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bGrainTrade)
			bGrainTrade = set.TSResearch("Grain Trade");
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
	if (hero.IsValid) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//cult of Horus + buy slaves
{
	bool bHorusCult = false, bSlaves = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bHorusCult || !bSlaves)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bHorusCult)
			bHorusCult = set.TSResearch("Cult of Horus");
		if (!bSlaves)
			bSlaves = set.TSResearch("BuySlaves");
		Sleep(4100 + rand(15) * 100);
	}
}

//light of Horus 1 + barrack level 1
{
	bool bHorusLight1 = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bHorusLight1 || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bHorusLight1)
			bHorusLight1 = set.TSResearch("Light of Horus I");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//light of Horus 2 + buy slaves
{
	bool bHorusLight2 = false, bSlaves = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bHorusLight2 || !bSlaves)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bHorusLight2)
			bHorusLight2 = set.TSResearch("Light of Horus II");
		if (!bSlaves)
			bSlaves = set.TSResearch("BuySlaves");
		Sleep(4100 + rand(15) * 100);
	}
}

//light of Horus 3 + 15 Horus warriors + 5 swordsmen + 10 archers + optional religious feast + 1 random charm
{
	int nCount, nHorusWarriors = 15, nSwordsmen = 5, nArchers = 10;
	bool bHorusLight3 = false, bReligiousFeast = false, bCharm = false;
	StrArray charms;
	charms[0] = "Charm of Seth";
	charms[1] = "Charm of Thoth";
	charms[2] = "Charm of Ra";
	charms[3] = "Charm of Isis";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bHorusLight3 || olHorusWarriors.count < nHorusWarriors || olSwordsmen.count < nSwordsmen || olArchers.count < nArchers)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bHorusLight3)
			bHorusLight3 = set.TSResearch("Light of Horus III");
		if (bHorusLight3)
			if (olHorusWarriors.count < nHorusWarriors) {//try to maximize research level potential
				nCount = nHorusWarriors - olHorusWarriors.count;
				olHorusWarriors.AddList(set.TSRecruitArmy("EHorusWarrior", nCount));
			}
		if (olSwordsmen.count < nSwordsmen) {
			nCount = nSwordsmen - olSwordsmen.count;
			olSwordsmen.AddList(set.TSRecruitArmy("ESwordsman", nCount));
		}
		if (olArchers.count < nArchers) {
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("EArcher", nCount));
		}
		if (!bReligiousFeast)
			bReligiousFeast = set.TSResearch("Religious Feast");
		olHorusWarriors.SetCommand("enter", set.GetCentralBuilding());
		olSwordsmen.SetCommand("enter", set.GetCentralBuilding());
		olArchers.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && !bCharm) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		bCharm = set.TSResearch(charms[rand(4)]);
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
		olHorusWarriors.SetCommand("attach", hero);
		olSwordsmen.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		Sleep(5000);
	}

olHorusWarriors.ClearDead();
olSwordsmen.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olHorusWarriors, false);
SetNoAIFlag(olSwordsmen, false);
SetNoAIFlag(olArchers, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);