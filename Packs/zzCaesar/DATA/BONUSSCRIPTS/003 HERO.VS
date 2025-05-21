//void, Settlement set, int playerid

Unit hero_unit;
ObjList hero_list;
str hero_class;
int Greece, r;

Sleep(100);

EnvWriteString(set, "StartingBonusP" + playerid, "BonusHero12");//currently unused in other script, but kept for consistency with other bonuses

Greece = ImperialRome;
r = set.GetCentralBuilding().race;

if (r == Gaul)
	hero_class = "GaulHero";
else if (r == RepublicanRome) {
	while (EnvReadInt(set, "ChooseRomanRace") != 1)
		Sleep(100);
	if (IsResearched(set, "ChooseRepublicanRome"))
		hero_class = "RepublicanRomanHero";
	else if (IsResearched(set, "ChooseImperialRome"))
		hero_class = "ImperialRomanHero";
	else
		hero_class = "PunicRomanHero";
}
else if (r == Carthage)
	hero_class = "CarthaginianHero";
else if (r == Iberia)
	hero_class = "IberianHero";
else if (r == Britain)
	hero_class = "BritonHero";
else if (r == Egypt)
	hero_class = "EgyptianHero";
else if (r == Germany)
	hero_class = "GermanHero";
else if (r == Greece)
	hero_class = "GreekHero";

hero_unit = Place(GetRandomHeroClass(hero_class, playerid), set.GetCentralBuilding().pos, playerid);
hero_unit.SetLevel(12);
set.ForceAddUnit(hero_unit);

hero_list.Add(hero_unit);

SetShortcutSel(playerid, 1, hero_list);