//void, Obj This

Sleep(500 + rand(501));

{
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		int mages;

		while (true) {
			mages = .StonehengeNumControllingMages;

			if (mages > 0) {
				if (.stamina < 100)
					.SetStamina(.stamina + 1);
				if (mages < 50)
					Sleep(14000 / mages);
			}

			Sleep(2000);
		}
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);