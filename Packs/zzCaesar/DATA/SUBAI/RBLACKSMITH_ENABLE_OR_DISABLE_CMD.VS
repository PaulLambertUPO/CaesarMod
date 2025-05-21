//void, Obj This

Building this;

this = This.AsBuilding();

.CmdDisable("Roman Archers");
.CmdDisable("Roman Velit");
.CmdDisable("Roman Principle");
.CmdDisable("Roman Scout");
.CmdDisable("Roman Full Armor");
.CmdDisable("Roman Praetorian");
.CmdDisable("Improve Praetorian Equipment");
.CmdDisable("Roman Chariot Wheels");
.CmdDisable("Strenghten Stronghold Defences I");
.CmdDisable("Strenghten Stronghold Defences II");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdEnable("Roman Archers");
	.CmdEnable("Roman Principle");
	.CmdEnable("Roman Scout");
	.CmdEnable("Strenghten Stronghold Defences I");
	.CmdEnable("Strenghten Stronghold Defences II");

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

while (1)
	Sleep(3600000);