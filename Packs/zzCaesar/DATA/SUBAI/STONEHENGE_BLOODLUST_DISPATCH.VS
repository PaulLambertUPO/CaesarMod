//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int cost;

	cost = GetCmdStaminaCost("bloodlust");
	if (.stamina >= cost) {
		.SetStamina(.stamina - cost);

		.GlobalSpellStart(gsBloodlust, player);

		.SetCommand("bloodlust");

		EnvWriteInt(this, "OwningPlayer", player);
	}
}