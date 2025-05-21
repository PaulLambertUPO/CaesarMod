WaitUnitsInArea(NO_Viriato, "A_Vilager", -1);

if (!IsFinished("FreeFirstDruid")) {
	SpawnNamed("NO_Peasant");
	Sleep(2000);
	RunConv("Peasant");
	GiveNote("Clue");
	ExploreArea(1, "A_ExploreME");
	Sleep(2000);
	NO_Peasant.Erase();
}