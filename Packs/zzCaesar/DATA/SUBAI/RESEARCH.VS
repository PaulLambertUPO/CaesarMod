//void, Obj This
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, NamePlr, <research>, NameSet, <research>, <value>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>]

Building this;
Settlement set;
str dest, token, name;
bool spec_already_done = false;

this = This.AsBuilding();
set = .settlement;

dest = cmdparam;

EnvWriteString(this, "researching", "yes");

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NamePlr") {
		name = ParseStr(dest, dest);
		EnvWriteString(.player, name, "researching");
		if (name == "Tribute") {
			Building th;
			th = set.GetCentralBuilding();
			th.GlobalSpellStart(gsTribute, .player);
			EnvWriteObj(.player, "TributeBuilding", th);
			PlaySound("Data/Sound Entities/StonehengeSpell.xml");
		}
		break;
	}
	else if (token == "NameSet") {
		name = ParseStr(dest, dest);
		EnvWriteString(set, name, "researching");
		if (name == "CLibyanFootman") {
			if (EnvReadString(set, "ResearchedLibyanFootman") == "yes")
				spec_already_done = true;
		}
		else if (name == "CJavelinThrower") {
			if (EnvReadString(set, "ResearchedJavelinThrower") == "yes")
				spec_already_done = true;
		}
		else if (name == "CBerberAssassin") {
			if (EnvReadString(set, "ResearchedBerberAssassin") == "yes")
				spec_already_done = true;
		}
		else if (name == "CMaceman") {
			if (EnvReadString(set, "ResearchedMaceman") == "yes")
				spec_already_done = true;
		}
		else if (name == "CNumidianRider") {
			if (EnvReadString(set, "ResearchedNumidianRider") == "yes")
				spec_already_done = true;
		}
		else if (name == "CHorseman")
			if (EnvReadString(set, "ResearchedHorseman") == "yes")
				spec_already_done = true;
		break;
	}
}

if (spec_already_done)
	.Progress(.cmddelay * 25 / 100);
else
	.Progress();

PlaySound(.player, "Data/Sound Entities/UpgradeComplete.xml");