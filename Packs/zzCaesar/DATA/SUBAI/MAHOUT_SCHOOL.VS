//void, Obj this

.Progress();

{
	int plr;

	plr = .player;

	EnvWriteInt(plr, "MaxElephants", EnvReadInt(plr, "MaxElephants") + 1);
}