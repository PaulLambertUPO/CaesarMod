//void, Settlement set

//plan: focus on a balanced group of basic troops, take path of the dead 2 to gain experience faster

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olSwordsmen, olArchers, olAxethrowers;
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

//cult of Anubis + buy slaves
{
	bool bAnubisCult = false, bSlaves = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bAnubisCult || !bSlaves)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bAnubisCult)
			bAnubisCult = set.TSResearch("Cult of Anubis");
		if (!bSlaves)
			bSlaves = set.TSResearch("BuySlaves");
		Sleep(4100 + rand(15) * 100);
	}
}

//path of the dead 1 + barrack level 1
{
	bool bPathDead1 = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bPathDead1 || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bPathDead1)
			bPathDead1 = set.TSResearch("Path of the dead I");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//path of the dead 2 + buy slaves
{
	bool bPathDead2 = false, bSlaves = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bPathDead2 || !bSlaves)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bPathDead2)
			bPathDead2 = set.TSResearch("Path of the dead II");
		if (!bSlaves)
			bSlaves = set.TSResearch("BuySlaves");
		Sleep(4100 + rand(15) * 100);
	}
}

//20 swordsmen + 15 archers + 15 axe throwers + optional religious feast + 1 random charm
{
	int nCount, nSwordsmen = 20, nArchers = 15, nAxethrowers = 15;
	bool bReligiousFeast = false, bCharm = false;
	StrArray charms;
	charms[0] = "Charm of Seth";
	charms[1] = "Charm of Thoth";
	charms[2] = "Charm of Ra";
	charms[3] = "Charm of Isis";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (olSwordsmen.count < nSwordsmen || olArchers.count < nArchers || olAxethrowers.count < nAxethrowers)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olSwordsmen.count < nSwordsmen) {
			nCount = nSwordsmen - olSwordsmen.count;
			olSwordsmen.AddList(set.TSRecruitArmy("ESwordsman", nCount));
		}
		if (olArchers.count < nArchers) {
			nCount = nArchers - olArchers.count;
			olArchers.AddList(set.TSRecruitArmy("EArcher", nCount));
		}
		if (olAxethrowers.count < nAxethrowers) {
			nCount = nAxethrowers - olAxethrowers.count;
			olAxethrowers.AddList(set.TSRecruitArmy("EAxetrower", nCount));
		}
		if (!bReligiousFeast)
			bReligiousFeast = set.TSResearch("Religious Feast");
		olSwordsmen.SetCommand("enter", set.GetCentralBuilding());
		olArchers.SetCommand("enter", set.GetCentralBuilding());
		olAxethrowers.SetCommand("enter", set.GetCentralBuilding());
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
		olSwordsmen.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		olAxethrowers.SetCommand("attach", hero);
		Sleep(5000);
	}

olSwordsmen.ClearDead();
olArchers.ClearDead();
olAxethrowers.ClearDead();
SetNoAIFlag(olSwordsmen, false);
SetNoAIFlag(olArchers, false);
SetNoAIFlag(olAxethrowers, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);