//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Obj this;
int cost;

this = objs[0];
cost = cmdcost_stamina;

if (.stamina >= cost) {
	EnvWriteInt(.AsBuilding(), "CasterPlayer", player);
	.SetStamina(.stamina - cost);
	.SetCommand(cmdparam);
}