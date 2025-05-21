//bool, ObjList objs, str OUT reasonText

Building this;
this = objs[0].AsBuilding();

reasonText = "";

if(.IsValid){
	if(EnvReadString(this.AsBuilding,"researching")=="yes"){
		reasonText = Translate(rollover(this,false));
		reasonText = reasonText + "\n<color 255 0 0>";
		reasonText = reasonText + Translatef("Requires %s1", "Trade Routes");
		return false;
	}
	if(EnvReadInt(.settlement,"IsStoring")==1) {
		return false;
	}
	if(EnvReadString(.settlement,"Trade Routes")!="researched"){
		reasonText = Translate(rollover(this,false));
		reasonText = reasonText + "\n<color 255 0 0>";
		reasonText = reasonText + Translatef("Requires %s1", "Trade Routes");
		return false;
	}
	if(.settlement.gold<800){
		reasonText = Translate(rollover(this,false));
		reasonText = reasonText + "\n<color 255 0 0>";
		reasonText = reasonText + Translate("Not enough gold");
	}
	return true;
}
return false;