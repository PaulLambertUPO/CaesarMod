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

Sleep(5000);//wait for a moment then execute the next queued command or repeat this one to attack a building that has been repaired in the meantime