//bool, Obj This, bool bAdd

if (bAdd)
	EnvWriteString(This.AsBuilding(), "researching", "yes");
else
	EnvWriteString(This.AsBuilding(), "researching", "no");

return true;