//void, Obj This

;//this empty instruction avoids problems due to starting the script with a scope

//use a scope to remove variables when the final loop is reached
{
	Building this;
	Settlement set;

	this = This.AsBuilding();

	.CmdDisable("RAddPop");
	.CmdDisable("buyfoodforgold");
	.CmdDisable("Free Wine");
	.CmdDisable("Import horses");
	.CmdDisable("Scout Area");
	.CmdDisable("Buy map");
	.CmdDisable("investR");
	.CmdDisable("RTribute");

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdDisable("ChooseRepublicanRome");
	.CmdDisable("ChooseImperialRome");
	.CmdDisable("ChoosePunicRome");

	.CmdEnable("RAddPop");
	.CmdEnable("Free Wine");
	.CmdEnable("Scout Area");
	.CmdEnable("investR");
	.CmdEnable("RTribute");

	if (IsResearched(set, "ChooseRepublicanRome"))
		.CmdEnable("buyfoodforgold");
	else if (IsResearched(set, "ChooseImperialRome"))
		.CmdEnable("Import horses");
	else if (IsResearched(set, "ChoosePunicRome")) {
		.CmdEnable("buyfoodforgold");
		.CmdEnable("Import horses");
		.CmdEnable("Buy map");
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);