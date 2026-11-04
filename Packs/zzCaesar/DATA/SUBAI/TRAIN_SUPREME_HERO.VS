//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	str hero_class;

	hero_class = cmdparam;

	EnvWriteString(this, "Build", hero_class);
	EnvWriteInt(this, "Build/" + hero_class, 1);
}