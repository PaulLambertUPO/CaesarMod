//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	Settlement set;

	set = .settlement;

	if (EnvReadInt(set, "IsStoring") == 1)
		if (EnvReadInt(set, "FoodStorage") < 100000000)
			if (set.food > 0) {
				EnvWriteInt(set, "FoodStorage", EnvReadInt(set, "FoodStorage") + MIN(10, set.food));
				set.SetFood(MAX(0, set.food - 10));
			}
}

Sleep(2000);