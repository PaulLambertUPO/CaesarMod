//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

if (GetTime() > EnvReadInt(player, "TakeNearbyItemsCooldown")) {//the cooldown reduces the lag caused by holding down the hotkey
	objs.SetCommand("take_nearby_items");
	EnvWriteInt(player, "TakeNearbyItemsCooldown", GetTime() + 1000);
}