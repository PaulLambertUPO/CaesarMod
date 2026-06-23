//void, Obj This

Building this;
ObjList strongholds, buildings;
Obj o;
str announcement;
int i, caster_player, duration = 10;

this = This.AsBuilding();

caster_player = EnvReadInt(this, "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + .pos.x + "_" + .pos.y;

strongholds = GetSettlements("BaseTownhall", 0);
for (i = strongholds.count - 1; i >= 0; i -= 1)
	buildings.AddList(strongholds[i].AsBuilding().settlement.Buildings);
buildings.AddList(GetSettlements("BaseShipyard", 0));
buildings.AddList(GetSettlements("Outpost", 0));

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

while (duration > 0) {
	i = duration % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("Player %s1 - Earthquake - %s2:0%s3", caster_player, duration / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("Player %s1 - Earthquake - %s2:%s3", caster_player, duration / 60, i));

	for (i = buildings.count - 1; i >= 0; i -= 1) {
		o = buildings[i];
		if (o.health > 0)
			if (o.player == caster_player)
				o.Damage(225);
			else
				o.Damage(300);
	}

	duration -= 1;
	Sleep(1000);
}