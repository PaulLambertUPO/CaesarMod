//void, int player

ObjList ol;
Hero h;
int i, c;

while (1) {
	ol = GetPlayerUnits(player, "Hero");
	ol.ClearDead();
	c = ol.count;
	for (i = 0; i < c; i += 1) {
		h = ol[i].AsHero();
		if (h.IsValid) {
			h.SetExperience(h.experience + 1);
			if (!h.InHolder)
				CreateFeedback("Experience", h);
		}
	}
	Sleep(30000);
}