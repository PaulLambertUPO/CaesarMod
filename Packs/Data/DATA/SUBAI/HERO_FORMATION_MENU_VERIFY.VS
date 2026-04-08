//bool, ObjList objs, str OUT reasonText

if (cmdwaiting == "") {
	Hero this;

	this = objs[0].AsHero();

	if (.IsValid)
		if (.IsAlive) {
			str form_name;

			form_name = .formation;

			if (form_name == cmdparam) {
				reasonText = "<color 255 255 0>" + Translatef("%s1 formation", form_name) + "\n<color 255 255 255>" + FormDescription(form_name) + "\n" + Translate("Select new formation");
				return true;
			}
		}
}

return false;