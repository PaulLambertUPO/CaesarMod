//void, int playerid

//this script shows a hint about map exploration

int player_buildings;

Sleep(5000);

player_buildings = Count(playerid, cBuilding);

Sleep(60000);

if (Count(playerid, cBuilding) <= player_buildings) {
	Obj obj;
	ShowTutorial(
		Translate("Exploration"),
		Translate("Send out troops to explore the area outside your stronghold (the command 'Explore' is very useful to do so while you concentrate on something else)."),
		obj
	);
}