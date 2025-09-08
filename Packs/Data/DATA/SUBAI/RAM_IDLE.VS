//void, Obj me

Unit this;
Obj target;

this = me.AsUnit();

target = .RamBestTarget();

if (target.IsValid)
	if (!target.AsBuilding().IsVeryBroken) {
		Sleep(100);
		.AddCommand(true, "attack", target);
		return;
	}

while (1)
	Sleep(3600000);