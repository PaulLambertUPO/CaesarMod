//void, Obj This

Sleep(250 + rand(251));

{
	Unit this;

	this = This.AsUnit();

	if (.IsValid) {
		bool bonus_gained = false, bonus_chance = true;

		while (.IsAlive) {
			if (.IsVisible) {
				if (!bonus_chance) {
					if (bonus_gained) {
						Sleep(1200);//give some time to the unit to complete at least 1-2 attacks before the bonus expires
						if (.IsAlive)
							.RemoveBonus(12, 0, 0, 0, 0);
						bonus_gained = false;
					}
					bonus_chance = true;
				}
			}
			else if (bonus_chance) {
				if (rand(4) > 0)
					if (IsResearched(.player, "Gambler's Test")) {
						.AddBonus(12, 0, 0, 0, 0);
						bonus_gained = true;
					}
				bonus_chance = false;
			}
			Sleep(500);
		}
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);