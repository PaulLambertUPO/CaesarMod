//void, Settlement set

//plan: focus on a frenzied group of berber assassins, take spoils of war and mercenary pact because many will die

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olBerberAssassins;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsWisdom;
aSkills[1] = hsAdministration;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//hero + swords + dark rituals + free trade + barrack level 1
{
	bool bSwords = false, bDarkRituals = false, bFreeTrade = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bSwords || !bDarkRituals || !bFreeTrade || !bBarrack1)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bSwords)
			bSwords = set.TSResearch("Forge swords");
		if (!bDarkRituals)
			bDarkRituals = set.TSResearch("Dark Rituals");
		if (!bFreeTrade)
			bFreeTrade = set.TSResearch("Free Trade");
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
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

//slavery + people assembly
{
	bool bSlavery = false, bAssembly = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bSlavery || !bAssembly)) {
		if (hero.IsValid)
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
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bMercenaryPact || !bWarSpoils)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bMercenaryPact)
			bMercenaryPact = set.TSResearch("Mercenary pact");
		if (!bWarSpoils)
			bWarSpoils = set.TSResearch("Spoils of war");
		Sleep(4100 + rand(15) * 100);
	}
}

//barrack level 2 + 30 berber assassins + possible slavery
{
	int nCount, nBerberAssassins = 30;
	bool bBarrack2 = false, bSlavery = false;
	str supportCmd = "CSellFood";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olBerberAssassins.count < nBerberAssassins)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2)
			if (olBerberAssassins.count < nBerberAssassins) {
				nCount = nBerberAssassins - olBerberAssassins.count;
				olBerberAssassins.AddList(set.TSRecruitArmy("CBerberAssassin", nCount));
			}
		if (!bSlavery)
			bSlavery = set.TSResearch("Slavery");
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olBerberAssassins.SetCommand("enter", set.GetCentralBuilding());
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
		olBerberAssassins.SetCommand("attach", hero);
		Sleep(5000);
	}

olBerberAssassins.ClearDead();
SetNoAIFlag(olBerberAssassins, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);