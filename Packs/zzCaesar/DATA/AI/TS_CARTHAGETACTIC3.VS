//void, Settlement set

//plan: focus on a ruthless group of macemen, take spoils of war and mercenary pact because many will die

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olMacemen;
int aiPlayer, heroScriptId;
bool bHeroScript = false;

aiPlayer = set.player;

SetAIVar(aiPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsWisdom;
aSkills[1] = hsAdministration;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//hero + maces + dark rituals + free trade + barrack level 1
{
	bool bMaces = false, bDarkRituals = false, bFreeTrade = false, bBarrack1 = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (hero.IsDead || !bMaces || !bDarkRituals || !bFreeTrade || !bBarrack1)) {
		if (hero.IsDead)
			hero = set.TSRecruitHero();
		if (!bMaces)
			bMaces = set.TSResearch("Forge maces");
		if (!bDarkRituals)
			bDarkRituals = set.TSResearch("Dark Rituals");
		if (!bFreeTrade)
			bFreeTrade = set.TSResearch("Free Trade");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
	if (hero.IsAlive) {
		Obj objDummy;
		ObjList ol;
		ol.Add(hero);
		hero.KillCommand();
		hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		heroScriptId = AIRun("TS_AttackAtWill.vs", set, ol, objDummy, 0);
		bHeroScript = true;
	}
}

//slavery + people assembly
{
	bool bSlavery = false, bAssembly = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bSlavery || !bAssembly)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bSlavery)
			bSlavery = set.TSResearch("Slavery");
		if (!bAssembly)
			bAssembly = set.TSResearch("People's Assembly");
		Sleep(4100 + rand(15) * 100);
	}
}

//mercenary pact + spoils of war
{
	bool bMercenaryPact = false, bWarSpoils = false;
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bMercenaryPact || !bWarSpoils)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bMercenaryPact)
			bMercenaryPact = set.TSResearch("Mercenary pact");
		if (!bWarSpoils)
			bWarSpoils = set.TSResearch("Spoils of war");
		Sleep(4100 + rand(15) * 100);
	}
}

//30 macemen + barrack level 2 + possible slavery
{
	int nCount, nMacemen = 30;
	bool bBarrack2 = false, bSlavery = false;
	str supportCmd = "CSellFood";
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olMacemen.count < nMacemen)) {
		if (hero.IsAlive)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2)
			if (olMacemen.count < nMacemen) {
				nCount = nMacemen - olMacemen.count;
				olMacemen.AddList(set.TSRecruitArmy("CMaceman", nCount));
			}
		if (!bSlavery)
			bSlavery = set.TSResearch("Slavery");
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olMacemen.SetCommand("enter", set.GetCentralBuilding());
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
	olMacemen.SetCommand("attach", hero);
	attached = hero.army.count;
	for (i = 0; i < 2; i += 1) {//wait for units to attach to the hero (2 attempts)
		Sleep(10000);
		if (hero.army.count > attached)
			break;
	}
}

olMacemen.ClearDead();
SetNoAIFlag(olMacemen, false);

SetAIVar(aiPlayer, AIV_WaitTactic, 0);