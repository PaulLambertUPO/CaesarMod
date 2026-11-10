//void, Obj This

ObjList player_units;
Obj o;
str announcement;
int i, j, k, caster_player;

caster_player = EnvReadInt(This.AsBuilding(), "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + This.pos.x + "_" + This.pos.y;

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

for (i = 1; i <= 16; i += 1) {
	if (i == caster_player)
		k = 8;
	else
		k = 7;
	player_units = GetPlayerUnits(i);
	for (j = player_units.count - 1; j >= 0; j -= 1)
		if (j % k == 0) {
			o = player_units[j];
			if (o.IsAlive)
				if (!o.IsHeirOf("BaseAnimal"))
					o.AsUnit().Disease();
		}
}

j = 60;
while (j > 0) {
	i = j % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("P.%s1 - Plague - %s2:0%s3", caster_player, j / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("P.%s1 - Plague - %s2:%s3", caster_player, j / 60, i));
	j -= 1;
	Sleep(1000);
}