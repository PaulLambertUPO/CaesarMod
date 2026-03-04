//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteString(.AsBuilding(), "researching", "no");

	EnvWriteInt(plr, "MaxMyrmidons", MIN(GetConst("MaxMyrmidonsValue"), EnvReadInt(plr, "MaxMyrmidons") + 10));

	PlaySound(plr, "Data/Sounds Entities/UpgradeComplete.xml");
}