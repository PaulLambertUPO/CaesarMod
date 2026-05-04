//bool, ObjList objs, str OUT reasonText

if (GetTime() > EnvReadInt(objs[0].player, "StandPositionCooldown"))//the cooldown reduces the lag caused by holding down the hotkey
	return true;

reasonText = rollover();

return false;