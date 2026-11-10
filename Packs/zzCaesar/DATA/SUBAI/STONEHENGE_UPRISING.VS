//void, Obj This

ObjList villages;
Settlement set;
str announcement;
int i, caster_player, d = 120;

caster_player = EnvReadInt(This.AsBuilding(), "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + This.pos.x + "_" + This.pos.y;

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

while (d > 0) {
	i = d % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("P.%s1 - Uprising - %s2:0%s3", caster_player, d / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("P.%s1 - Uprising - %s2:%s3", caster_player, d / 60, i));
	d -= 1;
	Sleep(1000);
}

PlaySound("Data/Sound Entities/Uprising.xml");

GetSettlements("Outpost", 0).SetPlayer(15);

d = GetConst("MinPopulation") + 1;//keep at least 1 population above minimum for the autorepair

villages = GetSettlements("BaseVillage", 0);

for (i = villages.count - 1; i >= 0; i -= 1) {
	set = villages[i].AsBuilding().settlement;
	if (set.population > d)
		if (set.player == caster_player)
			set.AddToPopulation(-MIN(10, set.population - d));
		else
			set.AddToPopulation(-MIN(20, set.population - d));
}