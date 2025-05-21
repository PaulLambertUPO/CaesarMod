//void, int playerid

//this script shows a hint about building selection

ObjList player_buildings;
int i;

Sleep(20000);

player_buildings = ClassPlayerObjs(cBuilding, playerid).GetObjList();

if (player_buildings.count > 0) {
	for (i = 0; i < player_buildings.count; i += 1)
		if (player_buildings[i]._LastSelectionTime() != -1)
			return;
	ShowTutorial(
		Translate("Select a building"),
		Translate("Every building has its use. To examine what a building can do, select it and check its list of commands. Some buildings can be used to recruit units, others to store resources, others to protect and heal the troops... Buildings are repaired automatically based on the number of units sheltered inside them, unless they are very damaged: in that case, they must be repaired by spending some gold."),
		player_buildings[0]
	);
}