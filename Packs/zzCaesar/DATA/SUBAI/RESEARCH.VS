//void, Obj This
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, SetsSet, <env>, <value>, SetsPlr, <env>, <value>, NameSet, <research>, <value>, NamePlr, <research>, <value>]

Building this;
Settlement set;
str dest, token, name;
int player;
bool spec_already_done = false;

this = This.AsBuilding();
set = .settlement;

dest = cmdparam;

player = .player;

EnvWriteString(this, "researching", "yes");

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NamePlr") {
		name = ParseStr(dest, dest);
		EnvWriteString(player, name, "researching");
		if (name == "Tribute") {
			Building th;
			th = set.GetCentralBuilding();
			th.GlobalSpellStart(gsTribute, player);
			EnvWriteObj(player, "TributeBuilding", th);
			PlaySound("Data/Sound Entities/StonehengeSpell.xml");
		}
		else if (name == "Protection of Apollo") {
			ShowAnnouncement("ApolloProtectionP" + player, Translatef("Player %s1 - soon protected", player));
			PlaySound("Data/Sound Entities/StonehengeSpell.xml");
		}
	}
	else if (token == "NameSet") {
		name = ParseStr(dest, dest);
		EnvWriteString(set, name, "researching");
		if (name == "Forge spears") {
			if (EnvReadString(set, "ResearchedLibyanFootman") == "yes")
				spec_already_done = true;
		}
		else if (name == "Forge javelins") {
			if (EnvReadString(set, "ResearchedJavelinThrower") == "yes")
				spec_already_done = true;
		}
		else if (name == "Forge swords") {
			if (EnvReadString(set, "ResearchedBerberAssassin") == "yes")
				spec_already_done = true;
		}
		else if (name == "Forge maces") {
			if (EnvReadString(set, "ResearchedMaceman") == "yes")
				spec_already_done = true;
		}
		else if (name == "Forge pikes") {
			if (EnvReadString(set, "ResearchedNumidianRider") == "yes")
				spec_already_done = true;
		}
		else if (name == "Forge shields") {
			if (EnvReadString(set, "ResearchedHorseman") == "yes")
				spec_already_done = true;
		}
	}
	else if (token == "break")//used only by Spartan/Special Training
		break;
}

if (spec_already_done)
	.Progress(.cmddelay / 4);
else
	.Progress();

PlaySound(player, "Data/Sound Entities/UpgradeComplete.xml");