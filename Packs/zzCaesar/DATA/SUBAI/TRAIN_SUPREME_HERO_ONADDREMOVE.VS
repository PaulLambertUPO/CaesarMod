//bool, Obj This, bool bAdd

str hero_class;
int plr;

hero_class = cmdparam;
plr = This.player;

if (bAdd) {
	if (Count(plr, hero_class) + EnvReadInt(plr, "QueuedBuild/" + hero_class) >= 1)
		return false;
	EnvWriteInt(plr, "QueuedBuild/" + hero_class, 1);
}
else
	EnvWriteInt(plr, "QueuedBuild/" + hero_class, 0);

return true;