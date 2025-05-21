//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
Hero h;
int i;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid) {
		h = u.hero;
		if (h.IsValid) {
			if (h.command == "teleport")
				u.SetCommand("idle");
			else if (h.InHolder)
				if (h.GetHolderSett().GetCentralBuilding().IsHeirOf("Teleport"))
					u.SetCommand("idle");
			u.DetachFrom(h);
		}
	}
}