//void, Obj This

Building this;
ObjList strongholds;
Building b;
Settlement set;
Unit u;
point pt_pos;
str announcement;
int i, j, k, caster_player, u_level, d = 180;

this = This.AsBuilding();

pt_pos = .pos;
caster_player = EnvReadInt(this, "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + pt_pos.x + "_" + pt_pos.y;

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

while (d > 0) {
	i = d % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("Player %s1 - Teuton horde - %s2:0%s3", caster_player, d / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("Player %s1 - Teuton horde - %s2:%s3", caster_player, d / 60, i));
	d -= 1;
	Sleep(1000);
}

d = GetConst("MinPopulation");

strongholds = GetSettlements("BaseTownhall", 0);

for (i = strongholds.count - 1; i >= 0; i -= 1) {
	b = strongholds[i].AsBuilding();
	pt_pos = b.pos;
	j = b.player;
	if (j == caster_player)
		u_level = 18;
	else
		u_level = 12;
	set = b.settlement;
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