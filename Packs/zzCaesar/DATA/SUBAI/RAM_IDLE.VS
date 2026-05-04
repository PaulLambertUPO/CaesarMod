//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Building target;

			target = .RamBestTarget.AsBuilding();

			if (target.IsValid)
				if (!target.IsVeryBroken) {
					.AddCommand(true, "attack", target);
					Sleep(30);//prevent possible loops with other commands
					return;
				}
		}

while (true)
	Sleep(3600000);