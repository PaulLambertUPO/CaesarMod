StrArray set_names;
str siege_group_name;
int i, attack_interval, timer;

attack_interval = 480000 - GetDifficulty() * 60000;
timer = attack_interval - rand(180001);

set_names[0] = "S_BritVillage4";
set_names[1] = "S_BritonOutpost3";
set_names[2] = "S_BritVillage1";
set_names[3] = "S_IceniTown";

while (GreenTown.obj.player == 3) {
	Sleep(10000);
	if (GreenTown.obj.player == 3) {
		timer -= 10000;
		if (timer <= 0) {
			timer = attack_interval - rand(60001);
			SpawnGroupInHolder("GreenAttackers4", "S_GreenTown");
			GreenAttackers4.AddToGroup("GreenAttackers4Siege0");
			GreenAttackers4.RemoveFromGroup("GreenAttackers4");
		}
		for (i = 0; i < 4; i += 1) {
			siege_group_name = "GreenAttackers4Siege" + i;
			if (!Group(siege_group_name).IsEmpty())
				if (GetSettlement(set_names[i]).player != 3) {
					if (!IsAIHelperRunning("AI_" + siege_group_name))
						RunAIHelper("AI_" + siege_group_name, "siege", siege_group_name, set_names[i]);
				}
				else {
					StopAIHelper("AI_" + siege_group_name);
					Group(siege_group_name).AddToGroup("GreenAttackers4Siege" + MIN(3, i + 1));
					Group(siege_group_name).RemoveFromGroup(siege_group_name);
				}
		}
	}
}