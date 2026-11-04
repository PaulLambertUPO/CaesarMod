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
		else if (This.IsHeirOf("Mist")) {
			This.MagicActionEnd();
			while (This.GetAnim() > 0)
				Sleep(500 + This.TimeToAnimFinish);//anims 2-3 (see "mist_idle.vs")
		}
		else if (This.IsHeirOf("CoverOfMercy"))
			while (This.GetAnim() > 0)
				Sleep(500 + This.TimeToAnimFinish);//anims 2-3 (see "coverofmercy_idle.vs")

		This.Damage(This.health);
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(86400000);