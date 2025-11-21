//void, Obj This

if (This.AsBuilding().IsValid) {
	Settlement this;

	this = This.AsBuilding().settlement;

	if (.IsValid)
		while (1) {
			if (EnvReadInt(this, "IsStoring") == 1)
				if (EnvReadInt(this, "FoodStorage") < 100000000)
					if (.food > 0) {
						EnvWriteInt(this, "FoodStorage", EnvReadInt(this, "FoodStorage") + MIN(10, .food));
						.SetFood(MAX(0, .food - 10));
					}

			Sleep(2000);
		}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);