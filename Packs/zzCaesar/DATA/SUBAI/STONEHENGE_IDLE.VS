//void, Obj This

Sleep(500 + rand(501));

{
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		ObjList ol_chamber;
		Settlement set;
		int mages;

		set = .settlement;

		while (true) {
			mages = .StonehengeNumControllingMages;

			if (mages > 0) {
				if (.stamina < 100) {
					ol_chamber = set.ObjectsAround("GDruid");

					if (ol_chamber.count <= 0) {
						ol_chamber = set.ObjectsAround("BDruid");
						if (ol_chamber.count <= 0)
							ol_chamber = set.ObjectsAround("TEnchantress");
					}

					if (ol_chamber.count > 0)
						if (IsResearched(ol_chamber[0].player, "Ritual Chamber"))
							.SetStamina(MIN(100, .stamina + 2));
						else
							.SetStamina(.stamina + 1);
					else
						.SetStamina(.stamina + 1);
				}

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