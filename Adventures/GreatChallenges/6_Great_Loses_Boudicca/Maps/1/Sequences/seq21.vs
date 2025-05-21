StrArray set_names;
IntArray attack_intervals, timers;
str group_name;
int i, j;

attack_intervals[1] = 600000 - GetDifficulty() * 60000;
attack_intervals[2] = 1020000 - GetDifficulty() * 120000;
attack_intervals[3] = 1020000 - GetDifficulty() * 120000;
attack_intervals[4] = 1440000 - GetDifficulty() * 180000;
attack_intervals[5] = 1440000 - GetDifficulty() * 180000;
for (i = 1; i <= 5; i += 1)
	timers[i] = attack_intervals[i] - rand(120001);

set_names[0] = "S_RomeVillage2";
set_names[1] = "S_RomeVillage1";
set_names[2] = "S_RomanOutpost2";
set_names[3] = "S_RomeVillage5";
set_names[4] = "S_RomanOutpost6";
set_names[5] = "S_RomanOutpost5";
set_names[6] = "S_RomeVillage4";
set_names[7] = "S_RomanOutpost1";
set_names[8] = "S_RomeVillage3";
set_names[9] = "S_RomanOutpost4";
set_names[10] = "S_RomanOutpost3";
set_names[11] = "S_BritVillage2";
set_names[12] = "S_IceniTown";

while (RomeTown.obj.player == 5) {
	Sleep(10000);
	for (i = 1; i <= 5; i += 1) {
		timers[i] -= 10000;
		if (timers[i] <= 0) {
			Hero h;
			timers[i] = attack_intervals[i] - rand(120001);
			group_name = "RomanAttackers" + i;
			SpawnGroupInHolder(group_name, "S_RomeTown");
			h = Group(group_name + "Hero").GetObjList()[0].AsHero();
			Group(group_name + "Units").SetCommand("attach", h);
			Group(group_name + "Units").RemoveFromGroup(group_name + "Units");
			h.SetAutocast(true);
			h.RemoveFromGroup(group_name + "Hero");
			Group(group_name).AddToGroup(group_name + "Siege0");
			Group(group_name).RemoveFromGroup(group_name);
		}
		for (j = 0; j < 13; j += 1) {
			group_name = "RomanAttackers" + i + "Siege" + j;
			if (!Group(group_name).IsEmpty())
				if (GetSettlement(set_names[j]).player != 5) {
					if (!IsAIHelperRunning("AI_" + group_name))
						RunAIHelper("AI_" + group_name, "siege", group_name, set_names[j]);
				}
				else {
					StopAIHelper("AI_" + group_name);
					Group(group_name).AddToGroup("RomanAttackers" + i + "Siege" + MIN(12, j + 1));
					Group(group_name).RemoveFromGroup(group_name);
				}
		}
	}
}