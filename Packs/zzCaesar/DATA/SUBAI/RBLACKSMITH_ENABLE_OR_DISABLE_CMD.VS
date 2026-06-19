//void, Obj This

;//this empty instruction avoids problems due to starting the script with a scope

//use a scope to remove variables when the final loop is reached
{
	Building this;
	Settlement set;

	this = This.AsBuilding();

	.CmdDisable("Roman Archers");
	.CmdDisable("Roman Velit");
	.CmdDisable("Roman Principle");
	.CmdDisable("Roman Scout");
	.CmdDisable("Roman Full Armor");
	.CmdDisable("Spiked armor I");
	.CmdDisable("Spiked armor II");
	.CmdDisable("Spiked armor");
	.CmdDisable("Roman Chariot Wheels");
	.CmdDisable("Strengthen Stronghold Defences I");
	.CmdDisable("Strengthen Stronghold Defences II");

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdDisable("ChooseRepublicanRome");
	.CmdDisable("ChooseImperialRome");
	.CmdDisable("ChoosePunicRome");

	.CmdEnable("Roman Archers");
	.CmdEnable("Roman Principle");
	.CmdEnable("Roman Scout");
	.CmdEnable("Strengthen Stronghold Defences I");
	.CmdEnable("Strengthen Stronghold Defences II");

	if (IsResearched(set, "ChooseRepublicanRome")) {
		.CmdEnable("Roman Full Armor");
		.CmdEnable("Roman Chariot Wheels");
	}
	else if (IsResearched(set, "ChooseImperialRome")) {
		.CmdEnable("Roman Velit");
		.CmdEnable("Spiked armor I");
		.CmdEnable("Spiked armor II");
	}
	else if (IsResearched(set, "ChoosePunicRome"))
		.CmdEnable("Spiked armor");
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);