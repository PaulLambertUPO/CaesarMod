//void, Obj This

Building this;

this = This.AsBuilding();

.CmdDisable("trainRPriest");
.CmdDisable("trainRPriestPunic");
.CmdDisable("Altar of Jupiter");
.CmdDisable("Cloud of Plague");
.CmdDisable("Wrath of Jupiter");
.CmdDisable("God's Gift");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	if (IsResearched(set, "ChoosePunicRome"))
		.CmdEnable("trainRPriestPunic");
	else
		.CmdEnable("trainRPriest");

	.CmdEnable("Altar of Jupiter");
	.CmdEnable("Cloud of Plague");
	.CmdEnable("Wrath of Jupiter");
	.CmdEnable("God's Gift");
}

while (1)
	Sleep(3600000);