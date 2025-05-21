//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("teuton_horde");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.SetCommand("teuton_horde");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}