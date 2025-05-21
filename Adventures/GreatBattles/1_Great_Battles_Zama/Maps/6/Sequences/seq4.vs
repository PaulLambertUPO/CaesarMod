point p_view;
int i;

WaitEnvIntBetween("/En_SyphaxAssault", 1, 2, -1);

if (EnvReadInt("/En_SyphaxAssault") == 2)
	while (1) {
		Sleep(2000);
		NO_Masinissa.SetCommand("move", NO_Scipio.obj.posRH);
		if (NO_Masinissa.obj.DistTo(NO_Scipio.obj) < 400) {
			RunConv("SecondMeeting");
			GiveNote("Kill Syphax");
			NO_Masinissa.SetCommand("move", AreaCenter("A_MasinissaReturn"));
			break;
		}
	}

NO_Masinissa.SetMessengerStatus(false);

SpawnNamed("NO_Syphax").AsUnit().SetLevel(20 + GetDifficulty() * 10);
NO_Syphax.obj.AsHero().SetAutocast(true);
SpawnGroup("Q_SyphaxCamels");
while (i < 40) {
	Sleep(1000);
	SpawnGroup("Q_SpawnAssassin1").SetCommand("move", AreaCenter("A_AssassinDest1"));
	Q_SpawnAssassin1.AddCommand(false, "move", AreaCenter("A_AssassinDest2"));
	Q_SpawnAssassin1.AddCommand(false, "attack", GetRandomPointInArea("A_AssassinDest3"));
	Q_SpawnAssassin1.RemoveFromGroup("Q_SpawnAssassin1");
	SpawnGroup("Q_SpawnFootman1").SetCommand("move", AreaCenter("A_FootmenDest1"));
	Q_SpawnFootman1.AddCommand(false, "move", AreaCenter("A_FootmenDest2"));
	Q_SpawnFootman1.AddCommand(false, "attack", GetRandomPointInArea("A_FootmenDest3"));
	Q_SpawnFootman1.RemoveFromGroup("Q_SpawnFootman1");
	Sleep(1800);
	SpawnGroup("Q_SpawnAssassin2").SetCommand("move", AreaCenter("A_AssassinDest1"));
	Q_SpawnAssassin2.AddCommand(false, "move", AreaCenter("A_AssassinDest2"));
	Q_SpawnAssassin2.AddCommand(false, "attack", GetRandomPointInArea("A_AssassinDest3"));
	Q_SpawnAssassin2.RemoveFromGroup("Q_SpawnAssassin2");
	SpawnGroup("Q_SpawnFootman2").SetCommand("move", AreaCenter("A_FootmenDest1"));
	Q_SpawnFootman2.AddCommand(false, "move", AreaCenter("A_FootmenDest2"));
	Q_SpawnFootman2.AddCommand(false, "attack", GetRandomPointInArea("A_FootmenDest3"));
	Q_SpawnFootman2.RemoveFromGroup("Q_SpawnFootman2");
	i += 1;
	if (i == 10) {
		BlockUserInput();
		HideZoomMap();
		p_view = ViewPos();
		View(NO_Syphax.obj.pos, true);
		SetFog(false);
	}
	else if (i == 15) {
		RunConv("SyphaxSpeech");
		NO_Syphax.SetCommand("attack", AreaCenter("A_SyphaxDest"));
	}
	else if (i == 16) {
		Q_SyphaxCamels.SetCommand("attach", NO_Syphax);
		Q_MasinissaKillers.SetCommand("attack", AreaCenter("A_MasinissaKillersDest"));
	}
	else if (i == 18) {
		View(p_view, false);
		SetFog(true);
		UnblockUserInput();
	}
	else if (i == 30) {
		SpawnNamed("NO_SyphaxHero1").SetCommand("attack", AreaCenter("A_AssassinDest3"));
		SpawnNamed("NO_SyphaxHero2").SetCommand("attack", AreaCenter("A_FootmenDest3"));
		SpawnNamed("NO_SyphaxHero3").SetCommand("attack", AreaCenter("A_MasinissaKillersDest"));
		NO_SyphaxHero1.obj.AsHero().SetAutocast(true);
		NO_SyphaxHero2.obj.AsHero().SetAutocast(true);
		NO_SyphaxHero3.obj.AsHero().SetAutocast(true);
	}
}
Q_SyphaxArmy1.SetCommand("attach", NO_SyphaxHero1);
Q_SyphaxArmy2.SetCommand("attach", NO_SyphaxHero2);
Q_MasinissaKillers.SetCommand("attach", NO_SyphaxHero3);
Sleep(10000);

while (!Q_Syphax.IsEmpty()) {
	Q_SyphaxMainArmy.SetCommand("attack", NO_Scipio.obj.posRH);
	if (!Q_SyphaxSiegeArmy.IsEmpty())
		if (NO_Utica.obj.player == 1) {
			if (!IsAIHelperRunning("SyphaxSiege")) {
				Q_SyphaxSiegeArmy.RemoveFromGroup("Q_SyphaxMainArmy");
				Q_SyphaxSiegeArmy.AddToGroup("Q_SyphaxTmpSiege");
				RunAIHelper("SyphaxSiege", "siege", "Q_SyphaxTmpSiege", "S_Utica");
			}
		}
		else if (!Group("Q_SyphaxTmpSiege").IsEmpty()) {
			StopAIHelper("SyphaxSiege");
			Q_SyphaxSiegeArmy.AddToGroup("Q_SyphaxMainArmy");
			Q_SyphaxSiegeArmy.RemoveFromGroup("Q_SyphaxTmpSiege");
		}
	if (!Q_MasinissaKillers.IsEmpty())
		if (!Q_Masinissa.IsEmpty())
			Q_MasinissaKillers.SetCommand("attack", NO_Masinissa.obj.posRH);
		else {
			Q_MasinissaKillers.AddToGroup("Q_SyphaxMainArmy");
			Q_MasinissaKillers.RemoveFromGroup("Q_MasinissaKillers");
		}
	Sleep(10000);
}

if (!Union(Q_Masinissa, Q_Iberians).IsEmpty())
	RunConv("SyphaxDeath");
RemoveNote("Kill Syphax");

ClassPlayerObjs(cMilitary, 6).SetPlayer(2);
if (IsAIHelperRunning("SyphaxSiege"))
	StopAIHelper("SyphaxSiege");
if (NO_Utica.obj.player == 6)
	NO_Utica.obj.SetPlayer(1);

WaitEmptyQuery(Q_Iberians, -1);
EnvWriteInt("/En_AllowForbiddenArea", 1);
Sleep(25000);
while (!Q_NumidiansLeave.IsEmpty()) {
	Q_NumidiansLeave.SetCommand("move", AreaCenter("A_NumidiansLeave"));
	Intersect(Q_NumidiansLeave, AreaObjs("A_NumidiansLeave", cMilitary)).Erase();
	Sleep(5000);
}