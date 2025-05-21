//void, Obj This

Building this;
Settlement set;
int fishermen;

this = This.AsBuilding();
set = .settlement;

while (1) {
	Sleep(4000);
	if (.health >= 500) {
		fishermen = EnvReadInt(set, "Fishermen");
		if (fishermen > 0)
			set.SetFood(set.food + fishermen * rand(3));//fishing requires some luck
	}
	else
		EnvWriteInt(this, "Fishermen", 0);
}