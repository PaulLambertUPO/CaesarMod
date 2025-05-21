//void, Obj This

Building this;

this = This.AsBuilding();

.CmdDisable("Barrack Level 1");
.CmdDisable("Barrack Level 2");
.CmdDisable("Barrack Level 3");
.CmdDisable("trainRHastatus");
.CmdDisable("trainRArcher");
.CmdDisable("trainRGladiator");
.CmdDisable("trainRVelit");
.CmdDisable("trainRPrinciple");
.CmdDisable("trainRScout");
.CmdDisable("trainRTribune");
.CmdDisable("trainRPraetorianBase");
.CmdDisable("trainRPraetorianDiscounted");
.CmdDisable("Equip Chariot");
.CmdDisable("trainRHastatusPunic");
.CmdDisable("trainRArcherPunic");
.CmdDisable("trainRGladiatorPunic");
.CmdDisable("trainRPrinciplePunic");
.CmdDisable("trainRScoutPunic");
.CmdDisable("trainRPraetorianPunic");

//use a scope to remove settlement variable when the final loop is reached
{
	Settlement set;

	set = .settlement;

	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(250);

	.CmdEnable("Barrack Level 1");
	.CmdEnable("Barrack Level 2");
	.CmdEnable("Barrack Level 3");

	if (IsResearched(set, "ChooseRepublicanRome")) {
		.CmdEnable("trainRHastatus");
		.CmdEnable("trainRArcher");
		.CmdEnable("trainRGladiator");
		.CmdEnable("trainRPrinciple");
		.CmdEnable("trainRScout");
		.CmdEnable("trainRTribune");
		.CmdEnable("Equip Chariot");
	}
	else if (IsResearched(set, "ChooseImperialRome")) {
		.CmdEnable("trainRHastatus");
		.CmdEnable("trainRArcher");
		.CmdEnable("trainRVelit");
		.CmdEnable("trainRPrinciple");
		.CmdEnable("trainRScout");
		.CmdEnable("trainRPraetorianBase");
		while (!IsResearched(set, "Improve Praetorian Equipment"))
			Sleep(250);
		.CmdDisable("trainRPraetorianBase");
		.CmdEnable("trainRPraetorianDiscounted");
	}
	else if (IsResearched(set, "ChoosePunicRome")) {
		.CmdEnable("trainRHastatusPunic");
		.CmdEnable("trainRArcherPunic");
		.CmdEnable("trainRGladiatorPunic");
		.CmdEnable("trainRPrinciplePunic");
		.CmdEnable("trainRScoutPunic");
		.CmdEnable("trainRPraetorianPunic");
	}
}

while (1)
	Sleep(3600000);