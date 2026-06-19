//void, Obj This

Obj flag;

//use a scope to remove variables when the final loop is reached
{
	Building this;
	Settlement set;

	this = This.AsBuilding();

	.CmdDisable("createfoodmule1");
	.CmdDisable("creategoldmule1");
	.CmdDisable("createfoodmule2");
	.CmdDisable("creategoldmule2");
	.CmdDisable("autotrain_start");
	.CmdDisable("autotrain_stop");
	.CmdDisable("military_training");
	.CmdDisable("send_resources");
	.CmdDisable("autoattach");

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
	.CmdEnable("military_training");
	.CmdEnable("send_resources");
	.CmdEnable("autoattach");

	if (IsResearched(set, "ChooseRepublicanRome"))
		flag = Place("RepublicanRomeFlag", .pos + Point(65, -450), .player);
	else if (IsResearched(set, "ChooseImperialRome"))
		flag = Place("ImperialRomeFlag", .pos + Point(65, -448), .player);
}

while (true) {
	if (This.player != flag.player)
		flag.SetPlayer(This.player);
	Sleep(500);
}