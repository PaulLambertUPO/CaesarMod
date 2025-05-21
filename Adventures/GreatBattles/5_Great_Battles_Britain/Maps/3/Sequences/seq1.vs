IntArray surprise_areas;
int i, surprises;

while (surprises < 10) {
	for (i = 1; i <= 10; i += 1)
		if (surprise_areas[i] != 1)
			if (!ClassPlayerAreaObjs(cUnit, 1, "A_Surprise" + i).IsEmpty()) {
				ObjList ol;
				int j;
				ol = SpawnGroup("T_Surprise" + i);
				for (j = 0; j < ol.count; j += 1)
					if (ol[j].AsHero().IsValid)
						ol[j].AsHero().SetAutocast(true);
				RunAIHelper("Surprise" + i, "guard area", "T_Surprise" + i, "A_Surprise" + i);
				surprise_areas[i] = 1;
				surprises += 1;
			}
	Sleep(4000);
}