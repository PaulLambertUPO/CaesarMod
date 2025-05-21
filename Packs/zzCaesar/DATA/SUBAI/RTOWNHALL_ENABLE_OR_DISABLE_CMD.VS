//void, Obj This

Building this;
Unit flag;

this = This.AsBuilding();

.CmdEnable("ChooseRepublicanRome");
.CmdEnable("ChooseImperialRome");
.CmdEnable("ChoosePunicRome");
.CmdDisable("createfoodmule1");
.CmdDisable("creategoldmule1");
.CmdDisable("createfoodmule2");
.CmdDisable("creategoldmule2");
.CmdDisable("autotrain_start");
.CmdDisable("autotrain_stop");
.CmdDisable("townhall_military_training");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdDisable("ChooseRepublicanRome");
	.CmdDisable("ChooseImperialRome");
	.CmdDisable("ChoosePunicRome");

	.CmdEnable("createfoodmule1");
	.CmdEnable("creategoldmule1");
	.CmdEnable("createfoodmule2");
	.CmdEnable("creategoldmule2");
	.CmdEnable("autotrain_start");
	.CmdEnable("autotrain_stop");
	.CmdEnable("townhall_military_training");

	if (IsResearched(set, "ChooseRepublicanRome"))
		flag = Place("RepublicanRomeFlag", .pos + Point(167, -225), .player);
	else if (IsResearched(set, "ChooseImperialRome"))
		flag = Place("ImperialRomeFlag", .pos + Point(167, -225), .player);
}

while (1) {
	if (.player != flag.player)
		flag.SetPlayer(.player);
	Sleep(500);
}