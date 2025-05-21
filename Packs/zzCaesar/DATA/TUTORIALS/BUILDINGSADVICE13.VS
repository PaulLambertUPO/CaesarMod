//void, int playerid

//this script shows a hint about map exploration

int player_buildings;

Sleep(5000);

player_buildings = ClassPlayerObjs(cBuilding, playerid).count;

Sleep(60000);

if (ClassPlayerObjs(cBuilding, playerid).count <= player_buildings) {
	Obj obj;
	ShowTutorial(
		Translate("Exploration"),
		Translate("Send out troops to explore the area outside your stronghold (the command 'Explore' is very useful to do so while you concentrate on something else)."),
		obj
	);
}