//bool, Obj This, bool bAdd

Building this;

this = This.AsBuilding();

if (bAdd)
	if (EnvReadInt(.player, "MaxMyrmidons") >= GetConst("MaxMyrmidonsValue"))
		return false;
	else
		EnvWriteString(this, "researching", "yes");
else
	EnvWriteString(this, "researching", "no");

return true;