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
	.CmdDisable("Roman Praetorian");
	.CmdDisable("Improve Praetorian Equipment");
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
		.CmdEnable("Roman Praetorian");
		.CmdEnable("Improve Praetorian Equipment");
		while (!IsResearched(set, "Roman Praetorian"))
			Sleep(250);
		.CmdDisable("Roman Praetorian");
	}
	else if (IsResearched(set, "ChoosePunicRome"))
		.CmdEnable("Roman Praetorian");
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);