Building spell_stone;
Obj hall;
int i;

spell_stone = NO_SpellStone.obj.AsBuilding();
hall = NO_Town3;

while (true) {
	Sleep(10000);
	i = hall.player;
	if (i != 1)
		if (i != 7)
			if (ClassPlayerAreaObjs(cUnit, 1, "A_SpellStone").IsEmpty)
				if (ClassPlayerAreaObjs(cUnit, 7, "A_SpellStone").IsEmpty) {
					if (StoneDruids.IsEmpty)
						SpawnGroup("StoneDruids").SetCommand("stand_position");
					EnvWriteInt(spell_stone, "CasterPlayer", i);
					i = rand(200);
					if (i < 25)
						spell_stone.SetCommand("foraging");
					else if (i < 50)
						spell_stone.SetCommand("wisdom");
					else if (i < 75)
						spell_stone.SetCommand("exhaust");
					else if (i < 100)
						spell_stone.SetCommand("soothing");
					else if (i < 120)
						spell_stone.SetCommand("sacrifice");
					else if (i < 140)
						spell_stone.SetCommand("gold_rain");
					else if (i < 160)
						spell_stone.SetCommand("starvation");
					else if (i < 180)
						spell_stone.SetCommand("bloodlust");
					else if (i < 190)
						spell_stone.SetCommand("plague");
					else if (i < 195)
						spell_stone.SetCommand("earthquake");
					else if (i < 199)
						spell_stone.SetCommand("uprising");
					else
						spell_stone.SetCommand("teuton_horde");
					Sleep(500);
					while (spell_stone.command != "idle")
						Sleep(10000);
				}
}