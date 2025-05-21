StrArray researches;
int i;

researches[0] = "Veteran Offence";
researches[1] = "Veteran Defence";
researches[2] = "Veteran Health";

while (RomeTown.obj.player == 5) {
	Sleep(960000 - GetDifficulty() * 120000);
	if (RomeTown.obj.player != 5)
		break;
	RomeTown.obj.AsBuilding().Research(researches[i]);
	i += 1;
	if (i > 2)
		break;
}