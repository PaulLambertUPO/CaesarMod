//void, int playerid

//this script shows a hint about the minimap

Sleep(15000);

if (_ZoomMapLastShownTime() == -1) {
	Obj obj;
	ShowTutorial(
		Translate("Minimap"),
		Translate("To get a bird's eye view of the entire area, press the space bar or the mouse wheel to activate the minimap. From there you can determine your global strategy as well as select settlements and issue commands. Everything which isn't explored is marked in black."),
		obj
	);
}