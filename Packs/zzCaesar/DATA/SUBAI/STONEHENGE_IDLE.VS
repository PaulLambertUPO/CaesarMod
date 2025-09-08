//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	int count;

	while (1) {
		Sleep(3000);

		count = .StonehengeNumControllingMages();

		if (count > 0) {
			if (.stamina < 100)
				.SetStamina(.stamina + 1);
			if (count < 50)
				Sleep(15000 / count);
		}
	}
}

while (1)
	Sleep(3600000);