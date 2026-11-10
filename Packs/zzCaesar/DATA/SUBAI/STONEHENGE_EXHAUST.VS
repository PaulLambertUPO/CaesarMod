//void, Obj This

ObjList player_units;
Obj o;
str announcement;
int i, j, caster_player, duration = 30;

caster_player = EnvReadInt(This.AsBuilding(), "CasterPlayer");
announcement = "Ritual_" + caster_player + "_" + This.pos.x + "_" + This.pos.y;

PlaySound("Data/Sound Entities/StonehengeSpell.xml");

while (duration > 0) {
	i = duration % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("P.%s1 - Exhausting rain - %s2:0%s3", caster_player, duration / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("P.%s1 - Exhausting rain - %s2:%s3", caster_player, duration / 60, i));

	if (duration % 5 == 0)
		for (i = 1; i <= 16; i += 1) {
			player_units = GetPlayerUnits(i);
			for (j = player_units.count - 1; j >= 0; j -= 1) {
				o = player_units[j];
				if (o.IsAlive)
					if (o.stamina > 0) {
						if (o.player == caster_player)//check unit player instead of j because GetPlayerUnits takes units from other players that are attached to player j's heroes
							o.SetStamina(MAX(0, o.stamina - 5));
						else
							o.SetStamina(MAX(0, o.stamina - 10));
						CreateFeedback("StaminaLoss", o.AsUnit());
					}
			}
		}

	duration -= 1;
	Sleep(1000);
}