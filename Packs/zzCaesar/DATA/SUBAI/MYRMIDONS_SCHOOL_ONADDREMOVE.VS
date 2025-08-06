//bool, Obj This, bool bAdd

if (bAdd)
	if (EnvReadInt(This.player, "MaxMyrmidons") >= GetConst("MaxMyrmidonsValue"))
		return false;
	else
		EnvWriteString(This.AsBuilding(), "researching", "yes");
else
	EnvWriteString(This.AsBuilding(), "researching", "no");

return true;