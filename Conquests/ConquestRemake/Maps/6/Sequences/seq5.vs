Building spell_stone;
int player, power;

spell_stone = NO_SpellStone.obj.AsBuilding();

while (1) {
	Sleep(10000);
	player = NO_Town3.obj.player;
	if (player != 1)
		if (player != 7)
			if (ClassPlayerAreaObjs(cUnit, 1, "A_SpellStone").IsEmpty())
				if (ClassPlayerAreaObjs(cUnit, 7, "A_SpellStone").IsEmpty()) {
					if (StoneDruids.IsEmpty())
							SpawnGroup("StoneDruids").SetCommand("stand_position");
					power = rand(200);
					EnvWriteInt(spell_stone, "OwningPlayer", player);
					if (power < 30) {
						spell_stone.SetCommand("foraging");
						Sleep(40000);
					}
					else if (power < 60) {
						spell_stone.GlobalSpellStart(gsWindOfWisdom, player);
						spell_stone.SetCommand("wisdom");
						Sleep(20000);
					}
					else if (power < 90) {
						spell_stone.GlobalSpellStart(gsSoothingRain, player);
						spell_stone.SetCommand("soothing");
						Sleep(30000);
					}
					else if (power < 120) {
						spell_stone.GlobalSpellStart(gsDivineSacrifice, player);
						spell_stone.SetCommand("sacrifice");
						Sleep(60000);
					}
					else if (power < 140) {
						spell_stone.SetCommand("gold_rain");
						Sleep(120000);
					}
					else if (power < 160) {
						spell_stone.GlobalSpellStart(gsStarvation, player);
						spell_stone.SetCommand("starvation");
						Sleep(120000);
					}
					else if (power < 180) {
						spell_stone.GlobalSpellStart(gsBloodlust, player);
						spell_stone.SetCommand("bloodlust");
						Sleep(90000);
					}
					else if (power < 190) {
						spell_stone.SetCommand("plague");
						Sleep(60000);
					}
					else if (power < 199) {
						spell_stone.SetCommand("earthquake");
						Sleep(10000);
					}
					else {
						spell_stone.SetCommand("teuton_horde");
						Sleep(180000);
					}
				}
}