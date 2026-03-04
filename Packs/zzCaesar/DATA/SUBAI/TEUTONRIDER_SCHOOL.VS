//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteInt(plr, "MaxTeutonRiders", EnvReadInt(plr, "MaxTeutonRiders") + 10);

	EnvWriteString(plr, "Increase Horseshoe production", "researched");
}