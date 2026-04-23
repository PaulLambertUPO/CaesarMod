//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			point pt_pos;

			pt_pos = .pos;

			.Disappear();

			.AddToStoreBin();

			Sleep(2000);

			.RemoveFromStoreBin();

			.SetPos(pt_pos);
		}

Sleep(15);//prevent possible loops with other commands