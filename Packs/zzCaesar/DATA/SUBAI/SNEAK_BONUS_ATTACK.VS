//void, Obj This

Unit this;
bool bonus_gained = false, bonus_chance = false;

this = This.AsUnit();

Sleep(rand(251) + 250);

if (.IsValid)
	while (.IsAlive) {
		if (!.IsVisible()) {
			if (IsResearched(.player, "Gambler's Test"))
				if (!bonus_chance) {
					if (rand(4) != 0) {
						.AddBonus(12, 0, 0, 0, 0);
						bonus_gained = true;
					}
					bonus_chance = true;
				}
		}
		else if (bonus_chance) {
			if (bonus_gained) {
				bonus_gained = false;
				Sleep(1200);//give some time to the unit to complete at least 1-2 attacks before the bonus expires
				if (.IsValid)
					if (.IsAlive)
						.RemoveBonus(12, 0, 0, 0, 0);
			}
			bonus_chance = false;
		}
		Sleep(250);
	}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);