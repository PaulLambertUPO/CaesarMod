//void, Settlement set

//plan: focus on a resilient group of tuaregs and an unstoppable elephant, take spoils of war to maximize the gold gainings

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olTuaregs, olElephants;
int AIPlayer, heroScriptId;
bool bHeroScript = false;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsRecovery;
aSkills[1] = hsWisdom;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//hero + pikes + dark rituals + free trade + barrack level 1
{
	bool bPikes = false, bDarkRituals = false, bFreeTrade = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bPikes || !bDarkRituals || !bFreeTrade || !bBarrack1)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bPikes)
			bPikes = set.TSResearch("Forge pikes");
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

//spoils of war + barrack level 2
{
	bool bWarSpoils = false, bBarrack2 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bWarSpoils || !bBarrack2)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bWarSpoils)
			bWarSpoils = set.TSResearch("Spoils of war");
		if (!bBarrack2)
			bBarrack2 = set.TSResearch("Barrack Level 2");
		Sleep(4100 + rand(15) * 100);
	}
}

//25 tuaregs + 1 elephant + possible slavery
{
	int nCount, nTuaregs = 25, nElephants = 1;
	bool bSlavery = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (olTuaregs.count < nTuaregs || olElephants.count < nElephants)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (olTuaregs.count < nTuaregs) {
			nCount = nTuaregs - olTuaregs.count;
			olTuaregs.AddList(set.TSRecruitArmy("CNumidianRider", nCount));
		}
		if (olElephants.count < nElephants) {
			nCount = nElephants - olElephants.count;
			olElephants.AddList(set.TSArenaRecruit(nCount));
		}
		if (olElephants.count < nElephants)
			if (!set.CanAfford("Train War Elephant"))
				set.TSResearch("buyfoodforgold");
		if (!bSlavery)
			bSlavery = set.TSResearch("Slavery");
		olTuaregs.SetCommand("enter", set.GetCentralBuilding());
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
		olTuaregs.SetCommand("attach", hero);
		Sleep(5000);
	}

olTuaregs.ClearDead();
olElephants.ClearDead();
SetNoAIFlag(olTuaregs, false);
SetNoAIFlag(olElephants, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);