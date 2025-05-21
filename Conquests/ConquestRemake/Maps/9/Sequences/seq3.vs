IntArray camps;
int i, alerted_camps;

{
	Hero h;
	for (i = 1; i <= 4; i += 1) {
		Group("R_CampGuards" + i).SetCommand("stand_position");
		h = GetNamedObj("R_CampHero" + i).obj.AsHero();
		h.SetAutocast(true);
		h.SetFormation("Block");
		Group("R_CampPatrol" + i).SetCommand("attach", h);
		h.SetCommand("patrol", AreaCenter("A_Patrol" + i));
	}
}

while (alerted_camps < 4) {
	for (i = 1; i <= 4; i += 1)
		if (camps[i] != 1)
			if (!Union(
						Union(
							ClassPlayerAreaObjs(cMilitary, 1, "A_Camp" + i),
							ClassPlayerAreaObjs(cMilitary, 7, "A_Camp" + i)
						),
						ClassPlayerAreaObjs(cMilitary, 8, "A_Camp" + i)
					).IsEmpty()) {
				Wagon gold_mule;
				SpawnGroup("R_CampHelp" + i);
				RunAIHelper("GuardCamp" + i, "guard area", "R_CampGuards" + i, "A_Camp" + i);
				camps[i] = 1;
				alerted_camps += 1;
				gold_mule = GetNamedObj("R_Gold" + i).obj.AsWagon();
				if (gold_mule.IsValid)
					if (NO_Town5.obj.player != 1 && NO_Town5.obj.player != 7 && NO_Town5.obj.player != 8)
						gold_mule.SetCommand("unload", NO_Town5);
					else if (NO_Town4.obj.player != 1 && NO_Town4.obj.player != 7 && NO_Town4.obj.player != 8)
						gold_mule.SetCommand("unload", NO_Town4);
					else if (NO_Town2.obj.player != 1 && NO_Town2.obj.player != 7 && NO_Town2.obj.player != 8)
						gold_mule.SetCommand("unload", NO_Town2);
					else if (NO_Town3.obj.player != 1)
						if (NO_Town3.obj.player != 7)
							if (NO_Town3.obj.player != 8)
								gold_mule.SetCommand("unload", NO_Town3);
			}
	Sleep(2000);
}