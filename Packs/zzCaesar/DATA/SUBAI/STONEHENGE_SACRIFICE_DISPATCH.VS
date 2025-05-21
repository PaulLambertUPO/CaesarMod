//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("sacrifice");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.GlobalSpellStart(gsDivineSacrifice, player);

		.SetCommand("sacrifice");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}