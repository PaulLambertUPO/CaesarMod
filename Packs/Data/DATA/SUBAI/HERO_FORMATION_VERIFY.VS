//bool, ObjList objs, str OUT reasonText

str cmd_name;
int menu_type;

if (objs.count != 1)
	return false;

cmd_name = cmdwaiting;
if (cmd_name != "form-line-menu")
	if (cmd_name != "form-block-menu")
		if (cmd_name != "form-cavalry-menu")
			if (cmd_name != "form-front-menu")
				if (cmd_name != "form-skirmish-menu")
					if (cmd_name != "form-column-menu")
						return false;

reasonText = rollover(objs[0], true) + "\n" + FormDescription(cmdparam);
return true;