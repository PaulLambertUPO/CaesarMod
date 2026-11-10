//void, Obj This

ObjList settlements;
Settlement set;
Unit u;
Obj o;
point pt_pos;
str announcement;
int i, j, k, caster_player, u_level, d = 180;

pt_pos = This.pos;
caster_player = EnvReadInt(This.AsBuilding(), "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + pt_pos.x + "_" + pt_pos.y;

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

while (d > 0) {
	i = d % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("P.%s1 - Teuton horde - %s2:0%s3", caster_player, d / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("P.%s1 - Teuton horde - %s2:%s3", caster_player, d / 60, i));
	d -= 1;
	Sleep(1000);
}

PlaySound("Data/Sound Entities/TeutonHorde.xml");

d = GetConst("MinPopulation");

settlements = GetSettlements("BaseTownhall", 0);

for (i = settlements.count - 1; i >= 0; i -= 1) {
	o = settlements[i];
	pt_pos = o.pos;
	j = o.player;
	if (j == caster_player)
		u_level = 18;
	else
		u_level = 12;
	set = o.AsBuilding().settlement;
	set.SetPopulation(MIN(set.population, d));
	for (k = 0; k < 40; k += 1) {
		u = Place("TTeutonRiderMercenary", pt_pos, j).AsUnit();
		u.SetLevel(u_level);
		set.ForceAddUnit(u);
	}
	for (k = 0; k < 40; k += 1) {
		u = Place("TTeutonArcherMercenary", pt_pos, j).AsUnit();
		u.SetLevel(u_level);
		set.ForceAddUnit(u);
	}
	for (k = 0; k < 20; k += 1) {
		u = Place("TTeutonWolfMercenary", pt_pos, j).AsUnit();
		u.SetLevel(u_level);
		set.ForceAddUnit(u);
	}
}

settlements = GetSettlements("TTent", 0);
settlements.RemoveList(GetSettlements("CTent", 0));

for (i = settlements.count - 1; i >= 0; i -= 1) {
	set = settlements[i].AsBuilding().settlement;
	if (set.player == caster_player)
		set.SetFood(set.food + 4000);
	else
		set.SetFood(set.food + 2000);
}