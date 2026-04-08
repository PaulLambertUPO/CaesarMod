//void, Obj owner

if (owner.AsUnit().IsValid)
	while (true) {
		Sleep(1000);
		if (GetUseCount() > 0)
			SetUseCount(GetUseCount() - 1);
	}