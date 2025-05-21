StrArray set_names;
str siege_group_name;
int i, attack_interval, timer;

attack_interval = 480000 - GetDifficulty() * 60000;
timer = attack_interval - rand(180001);

set_names[0] = "S_RomanOutpost2";
set_names[1] = "S_RomanOutpost5";
set_names[2] = "S_IceniTown";

while (RomeTown.obj.player == 5) {
	Sleep(10000);
	timer -= 10000;
	if (timer <= 0) {
		timer = attack_interval - rand(60001);
		SpawnGroupInHolder("RomanAttackers6", "S_RomeTown");
		RomanAttackers6.AddToGroup("RomanAttackers6Siege0");
		RomanAttackers6.RemoveFromGroup("RomanAttackers6");
	}
	for (i = 0; i < 3; i += 1) {
		siege_group_name = "RomanAttackers6Siege" + i;
		if (!Group(siege_group_name).IsEmpty())
			if (GetSettlement(set_names[i]).player != 5) {
				if (!IsAIHelperRunning("AI_" + siege_group_name))
					RunAIHelper("AI_" + siege_group_name, "siege", siege_group_name, set_names[i]);
			}
			else {
				StopAIHelper("AI_" + siege_group_name);
				Group(siege_group_name).AddToGroup("RomanAttackers6Siege" + MIN(2, i + 1));
				Group(siege_group_name).RemoveFromGroup(siege_group_name);
			}
	}
}