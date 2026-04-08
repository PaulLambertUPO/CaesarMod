//void, Obj This

Sleep(250 + rand(251));

{
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		while (.IsAlive) {
			if (.HasSpecial(keen_sight))
				RevealHiddenEnemyUnits(.pos, .sight, .player);
			if (.HasSpecial(sneak))
				if (.TimeWithoutAttack >= 20000)
					if (.IsVisible)
						.SetVisible(false);
			if (.HasFreedom)
				if (.hero.IsValid)//this should happen only with adventure sequences
					.DetachFrom(.hero);
			Sleep(1000);
		}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);