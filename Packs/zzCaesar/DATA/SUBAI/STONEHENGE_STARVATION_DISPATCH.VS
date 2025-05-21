//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("starvation");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.GlobalSpellStart(gsStarvation, player);

		.SetCommand("starvation");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}