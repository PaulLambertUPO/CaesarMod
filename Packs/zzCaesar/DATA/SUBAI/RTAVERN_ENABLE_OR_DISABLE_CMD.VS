//void, Obj This

Building this;

this = This.AsBuilding();

.CmdDisable("RAddPop");
.CmdDisable("buyfoodforgold");
.CmdDisable("Free Wine");
.CmdDisable("Import horses");
.CmdDisable("Scout Area");
.CmdDisable("Buy map");
.CmdDisable("investR");
.CmdDisable("RTribute");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

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

while (1)
	Sleep(3600000);