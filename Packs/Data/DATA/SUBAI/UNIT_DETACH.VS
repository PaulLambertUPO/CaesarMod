//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Hero h;

		h = .hero;

		if (h.IsValid) {
			if (h.command == "teleport")
				.SetCommand("idle");
			else if (h.InHolder)
				if (!h.InShip)
					if (h.GetHolderSett().GetCentralBuilding().AsTeleport().IsValid)
						.SetCommand("idle");
			.DetachFrom(h);
		}
	}