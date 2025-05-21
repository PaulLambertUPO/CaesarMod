StrArray set_names;
IntArray attack_intervals, timers;
str group_name;
int i, j;

attack_intervals[1] = 600000 - GetDifficulty() * 60000;
attack_intervals[2] = 1020000 - GetDifficulty() * 120000;
attack_intervals[3] = 1440000 - GetDifficulty() * 180000;
for (i = 1; i <= 3; i += 1)
	timers[i] = attack_intervals[i] - rand(120001);

set_names[0] = "S_BritVillage4";
set_names[1] = "S_BritonOutpost3";
set_names[2] = "S_BritonOutpost2";
set_names[3] = "S_BritVillage3";
set_names[4] = "S_BritonOutpost1";
set_names[5] = "S_BritVillage2";
set_names[6] = "S_IceniTown";

while (GreenTown.obj.player == 3) {
	Sleep(10000);
	if (GreenTown.obj.player == 3)
		for (i = 1; i <= 3; i += 1) {
			timers[i] -= 10000;
			if (timers[i] <= 0) {
				Hero h;
				timers[i] = attack_intervals[i] - rand(120001);
				group_name = "GreenAttackers" + i;
				SpawnGroupInHolder(group_name, "S_GreenTown");
				h = Group(group_name + "Hero").GetObjList()[0].AsHero();
				Group(group_name + "Units").SetCommand("attach", h);
				Group(group_name + "Units").RemoveFromGroup(group_name + "Units");
				h.SetAutocast(true);
				h.RemoveFromGroup(group_name + "Hero");
				Group(group_name).AddToGroup(group_name + "Siege0");
				Group(group_name).RemoveFromGroup(group_name);
			}
			for (j = 0; j < 7; j += 1) {
				group_name = "GreenAttackers" + i + "Siege" + j;
				if (!Group(group_name).IsEmpty())
					if (GetSettlement(set_names[j]).player != 3) {
						if (!IsAIHelperRunning("AI_" + group_name))
							RunAIHelper("AI_" + group_name, "siege", group_name, set_names[j]);
					}
					else {
						StopAIHelper("AI_" + group_name);
						Group(group_name).AddToGroup("GreenAttackers" + i + "Siege" + MIN(6, j + 1));
						Group(group_name).RemoveFromGroup(group_name);
					}
			}
		}
}