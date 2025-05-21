Obj o1, o2;
bool first_talk = true;

while (!RuinDruids.IsEmpty()) {
	WaitConvRequest(ClassPlayerObjs(cUnit, 1), RuinDruids, 1000, o1, o2);
	if (o2.IsValid)
		if (o2.name == "RuinDruid1") {
			RunConv("RuinTalk1");
			o2.RemoveFromGroup("RuinDruids");
		}
		else if (o2.name == "RuinDruid2") {
			RunConv("RuinTalk2");
			o2.RemoveFromGroup("RuinDruids");
		}
		else if (first_talk) {
			RunConv("RuinTalk3");
			first_talk = false;
		}
		else {
			RunConv("RuinTalk4");
			if (ConvResult("RuinTalk4") == "YES")
				o2.RemoveFromGroup("RuinDruids");
		}
}

RemoveNote("Ruins");