//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("wisdom");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.GlobalSpellStart(gsWindOfWisdom, player);

		.SetCommand("wisdom");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}