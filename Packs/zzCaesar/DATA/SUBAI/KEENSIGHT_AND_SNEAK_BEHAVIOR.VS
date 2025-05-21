//void, Obj This

Unit this;

this = This.AsUnit();

Sleep(rand(250) + 250);

if (.IsValid)
	while (.IsAlive) {
		if (.HasSpecial(keen_sight))
			RevealHiddenEnemyUnits(.pos, .sight, .player);
		if (.HasSpecial(sneak))
			if (.TimeWithoutAttack >= 20000)
				if (.IsVisible)
					.SetVisible(false);
		Sleep(1000);
	}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);