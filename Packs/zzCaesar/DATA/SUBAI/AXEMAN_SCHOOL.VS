//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteInt(plr, "MaxAxemen", EnvReadInt(plr, "MaxAxemen") + 10);

	EnvWriteString(plr, "Increase Axe production", "researched");
}