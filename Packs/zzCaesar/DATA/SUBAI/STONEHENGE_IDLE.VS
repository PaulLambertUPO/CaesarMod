//void, Obj This

Sleep(500 + rand(501));

//use a scope to remove variables when the final loop is reached
{
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		int count;

		while (1) {
			Sleep(2000);

			count = .StonehengeNumControllingMages;

			if (count > 0) {
				if (.stamina < 100)
					.SetStamina(.stamina + 1);
				if (count < 50)
					Sleep(14000 / count);
			}
		}
	}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);