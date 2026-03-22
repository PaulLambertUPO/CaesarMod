//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("gold_rain");

	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		EnvWriteInt(this, "OwningPlayer", player);

		.SetCommand("gold_rain");
	}
}