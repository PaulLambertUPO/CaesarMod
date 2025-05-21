//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	int count;

	while (1) {
		Sleep(1000);

		count = .StonehengeNumControllingMages();

		if (count > 0) {
			if (.stamina < 100)
				.SetStamina(.stamina + 1);
			if (count < 50)
				Sleep(12500 / count - 250);
		}
	}
}
else
	while (1)
		Sleep(3600000);