//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteInt(plr, "MaxMacemen", EnvReadInt(plr, "MaxMacemen") + 10);

	EnvWriteString(plr, "Increase Mace production", "researched");
}