//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteInt(plr, "MaxHuntresses", EnvReadInt(plr, "MaxHuntresses") + 10);

	EnvWriteString(plr, "Increase Javelin production", "researched");
}