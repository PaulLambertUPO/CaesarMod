//void, int player

ObjList ol;
Hero h;
int i;

while (true) {
	ol = GetPlayerUnits(player, "Hero");
	for (i = ol.count - 1; i >= 0; i -= 1) {
		h = ol[i].AsHero();
		if (h.IsAlive) {
			h.SetExperience(h.experience + 1);
			CreateFeedback("Experience", h);
		}
	}
	Sleep(30000);
}