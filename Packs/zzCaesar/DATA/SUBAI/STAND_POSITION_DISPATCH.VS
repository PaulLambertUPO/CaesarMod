//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

if (GetTime() > EnvReadInt(player, "StandPositionCooldown")) {//the cooldown reduces the lag caused by holding down the hotkey
	objs.SetCommand("stand_position");
	EnvWriteInt(player, "StandPositionCooldown", GetTime() + 2000);
}