//void, Obj This

if (This.IsAlive) {
	int time;

	time = This.GetStaminaDecTime();

	if (time <= 0)
		This.Damage(This.health);

	while (This.IsAlive) {
		Sleep(time);
		if (This.IsAlive) {
			This.SetStamina(This.stamina - 1);
			if (This.stamina <= 0)
				break;
		}
	}

	if (This.IsAlive) {
		if (This.AsGhost().IsValid)
			This.MagicActionEnd();
		else if (This.IsHeirOf("Mist"))
			This.MagicActionEnd();

		This.Damage(This.health);
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);