//void, Settlement set

//plan: focus purely on a huge group of guardians supported by axe throwers

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olGuardians, olAxethrowers;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

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
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bGrainTrade || i < nExploringUnits)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bGrainTrade)
			bGrainTrade = set.TSResearch("Grain Trade");
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
	if (hero.IsAlive) {
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//barrack level 1 + buy slaves
{
	bool bBarrack1 = false, bSlaves = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack1 || !bSlaves)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		if (!bSlaves)
			bSlaves = set.TSResearch("BuySlaves");
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 2 + 20 guardians + 20 axe throwers + optional religious feast + 1 random charm
{
	int nCount, nGuardians = 20, nAxethrowers = 20;
	bool bBarrack2 = false, bReligiousFeast = false, bCharm = false;
	StrArray charms;
	charms[0] = "Charm of Seth";
	charms[1] = "Charm of Thoth";
	charms[2] = "Charm of Ra";
	charms[3] = "Charm of Isis";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olGuardians.count < nGuardians || olAxethrowers.count < nAxethrowers)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2) {
			if (olGuardians.count < nGuardians) {
				nCount = nGuardians - olGuardians.count;
				olGuardians.AddList(set.TSRecruitArmy("EGuardian", nCount));
			}
			if (olAxethrowers.count < nAxethrowers) {
				nCount = nAxethrowers - olAxethrowers.count;
				olAxethrowers.AddList(set.TSRecruitArmy("EAxetrower", nCount));
			}
		}
		if (!bReligiousFeast)
			bReligiousFeast = set.TSResearch("Religious Feast");
		olGuardians.SetCommand("enter", set.GetCentralBuilding());
		olAxethrowers.SetCommand("enter", set.GetCentralBuilding());
		Sleep(4100 + rand(15) * 100);
	}
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && !bCharm) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		bCharm = set.TSResearch(charms[rand(4)]);
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
	olGuardians.SetCommand("attach", hero);
	olAxethrowers.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
}

olGuardians.ClearDead();
olAxethrowers.ClearDead();
SetNoAIFlag(olGuardians, false);
SetNoAIFlag(olAxethrowers, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);