//void, Obj This

if (This.IsValid)
	if (!This.IsDead)
		if (!This.IsHeirOf("GGhostUnlimited")) {
			int time;

			time = This.GetStaminaDecTime();

			if (time <= 0)
				This.Damage(This.health);

			while (This.IsValid) {
				Sleep(time);
				if (This.IsValid)
					if (!This.IsDead) {
						This.SetStamina(This.stamina - 1);
						if (This.stamina <= 0)
							break;
					}
					else
						break;
			}

			if (This.IsValid)
				if (!This.IsDead) {
					if (This.IsHeirOf("GGhost"))
						This.MagicActionEnd();
					else if (This.IsHeirOf("Mist"))
						This.MagicActionEnd();

					This.Damage(This.health);
				}
		}

while (1)
	Sleep(3600000);