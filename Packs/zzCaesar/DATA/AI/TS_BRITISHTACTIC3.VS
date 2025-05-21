//void, Settlement set

//plan: focus on a combination of supporting archers for spearmen or highlanders depending on gambling, take also fights or steel weapons, get also gambler day

Hero hero;
IntArray aSkills, aSkillLevels;
ObjList olMeleeUnits, olArchers;
str upgradeTech, weaponTech, meleeUnitClass;
int AIPlayer, heroScriptId;
bool bHeroScript = false, bLuckyGambling;

AIPlayer = set.player;

SetAIVar(AIPlayer, AIV_WaitTactic, 1);

aSkills[0] = hsAssault;
aSkills[1] = hsEuphoria;
aSkillLevels[0] = 10;
aSkillLevels[1] = 10;

//hero + gambling + 4 exploring swordsmen
{
	int nExploringUnits = 4, i, gold, food;
	bool bGambling = false;
	str cmd = "trainBSwordsman";
	Barrack barrack;
	point ptDummy;
	Obj objDummy;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!hero.IsValid || !bGambling || i < nExploringUnits)) {
		if (!hero.IsValid)
			hero = set.TSRecruitHero();
		if (!bGambling)
			bGambling = set.TSResearch("Gambling");
		if (i < nExploringUnits) {
			barrack = set.BestBarrack(5);
			if (barrack.IsValid)
				if (GetCmdCost(cmd, gold, food)) {
					set.SpentGoldOnArmy(gold + food / 2);
					barrack.ExecCmd(cmd, ptDummy, objDummy, false);
				}
			i += 1;
		}
		Sleep(4100 + rand(15) * 100);//this interval combined with hero recruitment time makes sure that we can safely check settlement lucky environment variable
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

bLuckyGambling = EnvReadString(set, "LuckyGambling") == "yes";
if (bLuckyGambling) {
	upgradeTech = "Steel Weapons";
	weaponTech = "Britain Swords";
	meleeUnitClass = "BHighlander";
}
else {
	upgradeTech = "Britain Fights";
	weaponTech = "Britain Spears";
	meleeUnitClass = "BBronzeSpearman";
}

//gambler day + fights or steel weapons
{
	bool bGamblerDay = false, bUpgradeTech = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bGamblerDay || !bUpgradeTech)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bGamblerDay)
			bGamblerDay = set.TSResearch("Gambler's Day");
		if (!bUpgradeTech)
			bUpgradeTech = set.TSResearch(upgradeTech);
		Sleep(4100 + rand(15) * 100);
	}
}

//spears or swords + barrack level 1
{
	bool bWeaponTech = false, bBarrack1 = false;
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bWeaponTech || !bBarrack1)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bWeaponTech)
			bWeaponTech = set.TSResearch(weaponTech);
		if (!bBarrack1)
			bBarrack1 = set.TSResearch("Barrack Level 1");
		Sleep(4100 + rand(15) * 100);
	}
}

//10 spearmen or highlanders + 20 archers + lucky barrack level 2
{
	int nCount, nMeleeUnits = 10, nArchers = 20;
	bool bBarrack2 = false;
	str supportCmd = "BAddPop";
	while (AIVar(AIPlayer, AIV_WaitTactic) == 1 && (!bBarrack2 || olMeleeUnits.count < nMeleeUnits || olArchers.count < nArchers)) {
		if (hero.IsValid)
			hero.TSAdvHeroSkills(aSkills, aSkillLevels);
		if (!bBarrack2)
			if (!bLuckyGambling)
				bBarrack2 = true;
			else
				bBarrack2 = set.TSResearch("Barrack Level 2");
		if (bBarrack2) {
			if (olMeleeUnits.count < nMeleeUnits) {
				nCount = nMeleeUnits - olMeleeUnits.count;
				olMeleeUnits.AddList(set.TSRecruitArmy(meleeUnitClass, nCount));
			}
			if (olArchers.count < nArchers) {
				nCount = nArchers - olArchers.count;
				olArchers.AddList(set.TSRecruitArmy("BBowman", nCount));
			}
		}
		if (set.CanAfford(supportCmd))
			set.TSResearch(supportCmd);
		olMeleeUnits.SetCommand("enter", set.GetCentralBuilding());
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
		olMeleeUnits.SetCommand("attach", hero);
		olArchers.SetCommand("attach", hero);
		Sleep(5000);
	}

olMeleeUnits.ClearDead();
olArchers.ClearDead();
SetNoAIFlag(olMeleeUnits, false);
SetNoAIFlag(olArchers, false);

SetAIVar(AIPlayer, AIV_WaitTactic, 0);