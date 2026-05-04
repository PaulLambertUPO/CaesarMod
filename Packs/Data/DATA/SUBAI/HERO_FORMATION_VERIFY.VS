//bool, ObjList objs, str OUT reasonText

if (cmdwaiting != "") {
	reasonText = rollover() + "\n" + FormDescription(cmdparam);
	return true;
}

return false;