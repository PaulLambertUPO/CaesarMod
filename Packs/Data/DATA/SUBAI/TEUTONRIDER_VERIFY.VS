//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
int max_teutonriders;
str dest, name, reason;

this = objs[0];
dest = cmdparam;

max_teutonriders = EnvReadInt(.player, "MaxTeutonRiders");
if ((cmdcost_gold > this.AsBuilding.settlement.gold))
{
	reasonText = rollover(this,false)+ Translatef(" (currently %s1)",  "" + (max_teutonriders));
	reasonText = reasonText + "\n<color 255 0 0>";
	reasonText = reasonText + Translate("Not enough gold");
	
	return true;
}
reasonText = rollover(this,false) + Translatef(" (currently %s1)",  "" + (max_teutonriders));
return true;
