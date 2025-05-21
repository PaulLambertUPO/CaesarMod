WaitQueryCountBetween(G_GergoviaFrontLine, 0, 23, -1);

RunAIHelper("DefendMainReach", "guard area", "G_GergoviaFrontLine", "A_GergoviaEntrance");

WaitQueryCountBetween(G_GergoviaFrontLine, 0, 16, -1);

{
	ObjList ol;
	Unit u;
	int i;

	ol = SpawnGroup("G_GergoviaAmbush");

	for (i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsValid) {
			u.AddItem("Bear teeth amulet");
			u.AddItem("Belt of might");
			u.AddItem("Herb amulet of luck");
		}
	}

	ol.AddToGroup("G_GergoviaFrontLine");
}

if (!IsAIHelperRunning("DefendMainReach"))
	RunAIHelper("DefendMainReach", "guard area", "G_GergoviaFrontLine", "A_GergoviaEntrance");