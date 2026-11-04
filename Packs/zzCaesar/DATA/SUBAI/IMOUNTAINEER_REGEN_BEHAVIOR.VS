//void, Obj This

Sleep(250 + rand(251));

if (This.AsUnit().IsValid)
	while (This.IsAlive) {
		if (!This.IsVisible)
			if (IsResearched(This.player, "Survival techniques"))
				This.Heal(3);
		Sleep(2000);
	}

//without this instruction, the game crashes
while (true)
	Sleep(86400000);