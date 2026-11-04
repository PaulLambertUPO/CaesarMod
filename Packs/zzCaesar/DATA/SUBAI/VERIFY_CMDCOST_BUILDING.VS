//bool, ObjList objs, str OUT reasonText

str unit_class;

unit_class = cmdparam;

if (unit_class != "")
	reasonText = rollover(objs[0].AsBuilding(), unit_class, true);
else
	reasonText = rollover(objs[0].AsBuilding(), true);

return true;