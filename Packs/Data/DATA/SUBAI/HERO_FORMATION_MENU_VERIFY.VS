//bool, ObjList objs, str OUT reasonText

Hero this;
str form_name;

if (cmdwaiting != "")
	return false;

if (objs.count != 1)
	return false;

this = objs[0].AsHero;

form_name = this.AsHero().formation;
if (form_name == "")
	form_name = "Front";

if (form_name == cmdparam)
{
	reasonText = "<color 255 255 0>" + Translatef("%s1 formation", form_name) + "<color 255 255 255>";
	reasonText = reasonText + "\n";
	reasonText = reasonText + FormDescription(cmdparam);
	reasonText = reasonText + "\n";
	reasonText = reasonText + Translate("Select new formation");

	return true;
}

return false;