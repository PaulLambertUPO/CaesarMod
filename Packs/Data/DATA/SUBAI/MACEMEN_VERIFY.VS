//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
int max_macemen;
str dest, name, reason;

this = objs[0];
dest = cmdparam;

max_macemen = EnvReadInt(.player, "MaxMacemen");
if ((cmdcost_gold > this.AsBuilding.settlement.gold))
{
	reasonText = rollover(this,false)+ Translatef(" (currently %s1)",  "" + (max_macemen));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	
	return true;
}
reasonText = rollover(this,false) + Translatef(" (currently %s1)",  "" + (max_macemen));
return true;
