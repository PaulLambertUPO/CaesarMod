// void, Obj This, Obj target

Building Bld;

Bld = This.AsBuilding();


if (Bld.IsValid() && target.IsValid()) {
	if (Bld.settlement.IsOutpost() && Bld.settlement.IsIndependent)
	{
		return;
	}
	Bld.SetUITarget(target);
	Sleep(100);
}