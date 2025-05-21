//void, Obj This

Building this;

this = This.AsBuilding();

.CmdDisable("hireheroR");
.CmdDisable("RGladiator Shows");
.CmdDisable("Rome Training 1");
.CmdDisable("Rome Training 2");
.CmdDisable("Veteran Offence");
.CmdDisable("Veteran Defence");
.CmdDisable("Veteran Health");
.CmdDisable("RNobility");
.CmdDisable("Transition to Empire");
.CmdDisable("Hire Caesar");
.CmdDisable("hireheroRImperial");
.CmdDisable("RGladiator Shows2");
.CmdDisable("Standartization I");
.CmdDisable("Standartization II");
.CmdDisable("Flexibility");
.CmdDisable("Hire Liberati");
.CmdDisable("Liberati guild");
.CmdDisable("Liberati triumph");
.CmdDisable("Organize tournament");
.CmdDisable("Military Academy");
.CmdDisable("hireheroRPunic");
.CmdDisable("Gladiator Shows");
.CmdDisable("Training");
.CmdDisable("Advanced Training");
.CmdDisable("Special training");
.CmdDisable("Hire Liberati Punic");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	if (IsResearched(set, "ChooseRepublicanRome")) {
		.CmdEnable("hireheroR");
		.CmdEnable("RGladiator Shows");
		.CmdEnable("Rome Training 1");
		.CmdEnable("Rome Training 2");
		.CmdEnable("Veteran Offence");
		.CmdEnable("Veteran Defence");
		.CmdEnable("Veteran Health");
		.CmdEnable("RNobility");
		.CmdEnable("Transition to Empire");
		.CmdEnable("Hire Caesar");
	}
	else if (IsResearched(set, "ChooseImperialRome")) {
		.CmdEnable("hireheroRImperial");
		.CmdEnable("RGladiator Shows2");
		.CmdEnable("Standartization I");
		.CmdEnable("Standartization II");
		.CmdEnable("Flexibility");
		.CmdEnable("Hire Liberati");
		.CmdEnable("Liberati guild");
		.CmdEnable("Liberati triumph");
		.CmdEnable("Organize tournament");
		.CmdEnable("Military Academy");
	}
	else if (IsResearched(set, "ChoosePunicRome")) {
		.CmdEnable("hireheroRPunic");
		.CmdEnable("Gladiator Shows");
		.CmdEnable("Training");
		.CmdEnable("Advanced Training");
		.CmdEnable("Special training");
		.CmdEnable("Hire Liberati Punic");
		.CmdEnable("Liberati guild");
		.CmdEnable("Military Academy");
	}
}

while (1)
	Sleep(3600000);