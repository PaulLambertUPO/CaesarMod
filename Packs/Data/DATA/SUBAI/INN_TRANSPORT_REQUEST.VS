//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid)
	if (!.IsBroken)
		if (GetInnState(this) == 1) {
			Sleep(500);
			if (Intersect(ObjsInSight(this, "Unit"), PartyQuery).count == Party.count)
				.PopTransportationUI();
			else
				pr(Translate("Gather your party before traveling"));
		}
		else
			pr(Translate("This inn is closed"));
	else
		pr(Translate("This inn is too damaged"));