WaitQueryCountBetween(Q_Scipio, 1, 1000, -1);
WaitConvRequest(NO_Scipio, NO_Masinissa, -1);

RunConv("FirstMeeting");
ExploreAll();
_PlaceEx("WatchEye", 11503, 4533, 1);
RemoveNote("Meet Masinissa");
GiveNote("Landing site");
NO_Scipio.Heal(2000);
SpawnGroup("Q_Gladiators").SetCommand("attach", NO_Scipio);

SpawnGroupInHolder("Q_Trackers", "S_Utica").SetCommand("attach", NO_TrackerHero);
NO_TrackerHero.obj.AsUnit().SetLevel(10 + GetDifficulty() * 5);
NO_TrackerHero.obj.AsHero().SetAutocast(true);
NO_TrackerHero.SetCommand("attack", AreaCenter("A_CamelsPatrol"));
NO_TrackerHero.AddCommand(false, "patrol", AreaCenter("A_Trackers"));

EnvWriteInt("/En_IberiansArrived", 1);
_PlaceEx("WatchEye", 10867, 7579, 1);
_PlaceEx("WatchEye", 8111, 9918, 1);
_PlaceEx("WatchEye", 6820, 15305, 1);
Q_LandingGroup.SetPlayer(1);
Q_SupplyMules.SetPlayer(1);
Q_LandingGroup.SetCommand("attach", NO_Scipio);
Q_SupplyMules.SetCommand("follow", NO_Scipio);

while (1) {
	if (WaitEnvIntBetween("/En_IberiansDied", 1, 1, 500)) {
		int i, difficulty;
		WaitConvRequest(NO_Scipio, NO_Masinissa, -1);
		EnvWriteInt("/En_SyphaxAssault", 1);
		RunConv("SecondMeeting");
		RemoveNote("Return to Masinissa");
		GiveNote("Kill Syphax");
		difficulty = GetDifficulty();
		for (i = 2; i >= difficulty; i -= 1) {
			SpawnGroup("Q_Gladiators").SetCommand("attach", NO_Scipio);
			Q_Gladiators.RemoveFromAllGroups();
			Sleep(500);
		}
		break;
	}
	if (WaitEnvIntBetween("/En_SyphaxAssault", 2, 2, 500))
		break;
}

NO_Scipio.Heal(2000);
Sleep(40000);
DiplShareView(1, 6, true);
DiplShareView(6, 1, true);