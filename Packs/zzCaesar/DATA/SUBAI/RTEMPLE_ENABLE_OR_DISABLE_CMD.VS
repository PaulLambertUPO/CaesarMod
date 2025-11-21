//void, Obj This

;//this empty instruction avoids problems due to starting the script with a scope

//use a scope to remove variables when the final loop is reached
{
	Building this;
	Settlement set;

	this = This.AsBuilding();

	.CmdDisable("trainRPriest");
	.CmdDisable("trainRPriestPunic");
	.CmdDisable("Altar of Jupiter");
	.CmdDisable("Cloud of Plague");
	.CmdDisable("Wrath of Jupiter");
	.CmdDisable("God's Gift");

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdDisable("ChooseRepublicanRome");
	.CmdDisable("ChooseImperialRome");
	.CmdDisable("ChoosePunicRome");

	if (IsResearched(set, "ChoosePunicRome"))
		.CmdEnable("trainRPriestPunic");
	else
		.CmdEnable("trainRPriest");

	.CmdEnable("Altar of Jupiter");
	.CmdEnable("Cloud of Plague");
	.CmdEnable("Wrath of Jupiter");
	.CmdEnable("God's Gift");
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);