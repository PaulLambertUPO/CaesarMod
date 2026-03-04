//bool, ObjList objs, str OUT reasonText

if (cmdwaiting != "") {
	reasonText = rollover(objs[0], true) + "\n" + FormDescription(cmdparam);
	return true;
}

return false;