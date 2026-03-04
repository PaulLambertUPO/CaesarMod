//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
Hero h;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	u = objs[i].AsUnit();
	if (u.IsAlive) {
		h = u.hero;
		if (h.IsValid) {
			if (h.command == "teleport")
				u.SetCommand("idle");
			else if (h.InHolder)
				if (!h.InShip)
					if (h.GetHolderSett().GetCentralBuilding().AsTeleport().IsValid)
						u.SetCommand("idle");
			u.DetachFrom(h);
		}
	}
}