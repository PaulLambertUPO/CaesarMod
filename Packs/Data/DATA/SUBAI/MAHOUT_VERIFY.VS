//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
int max_elephants;
str dest, name, reason;

this = objs[0];
dest = cmdparam;
name = ParseStr(dest, dest);
reason = ParseStr(dest, dest);

max_elephants = EnvReadInt(.player, "MaxElephants");
if (reason == "")
{
	reason = rollover(this,false) + Translatef(" (currently %s1)", max_elephants) + "\n<color 255 0 0>";
	reason = reason + Translatef("Requires %s1", name);
}
else
	reason = rollover(this,false) +  Translatef(" (currently %s1)", max_elephants) + "\n<color 255 0 0>" + Translatef(reason,name);

if(this.AsBuilding.IsValid) {
  if(EnvReadString(this.AsBuilding.settlement, name) != "researched") {
    reasonText = reason;
    return false;
  }
}
else {
  reasonText = reason;
  return false;
}

if ((cmdcost_gold > this.AsBuilding.settlement.gold))
{
	reasonText = rollover(this,false)+ Translatef(" (currently %s1)",  "" + (max_elephants + 1));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	
	return true;
}
reasonText = rollover(this,false) + Translatef(" (currently %s1)",  "" + (max_elephants + 1));
return true;
