// void, Obj me

Unit this;
Obj target;

this = me.AsUnit();
target = .RamBestTarget();

if (!target.IsValid())
	while (1) Sleep(100000);
if (target.AsBuilding().IsBroken())
	while (1) Sleep(100000);

Sleep(100);

.SetCommand("attack", target);

