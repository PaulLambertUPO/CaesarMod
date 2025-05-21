//bool, ObjList objs, str OUT reasonText

Building this;
str strEnvStr_gold;
str strEnvStr_food;

if(objs.count > 0)
{
	this = objs[0].AsBuilding();
	if(.IsValid())
	{
        strEnvStr_gold = EnvReadString(.settlement, "GOutpostSellGold");
        strEnvStr_food = EnvReadString(.settlement, "GOutpostSellFood");
        
        if(strEnvStr_gold != "yes" && strEnvStr_food != "yes"){
            return true;
        }
        if (strEnvStr_gold != "yes" && strEnvStr_food=="yes"){
            reasonText = Translate(rollover(this,false));
            reasonText = reasonText + "\n<color 255 0 0>";
            reasonText = reasonText + Translate("(Another exchange is under way)");
            return false;
        }
	}
}
return false;
