//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("gold_rain");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.SetCommand("gold_rain");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}