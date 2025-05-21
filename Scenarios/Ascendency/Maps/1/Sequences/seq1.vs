Obj house;
str group;
int i, game_time, build_time;

while (1) {
	game_time += 1000;
	for (i = 1; i <= 32; i += 1) {
		house = GetNamedObj("House" + i).obj;
		if (house.player != 13)
			if (house.health > 3500) {
				group = EnvReadString("/House" + i);
				build_time = EnvReadInt("/BuildTime/" + group);
				if (game_time % build_time == 0)
					if (Group("Summoned" + i).count < 240000 / build_time) {//see comments in sequence "Start"
						SpawnGroupInHolder(group, "Out" + i).SetPlayer(house.player);
						Group(group).AddToGroup("Summoned" + i);
						Group(group).RemoveFromGroup(group);
					}
			}
	}
	if (game_time > 40000)//max value of /BuildTime
		game_time = 0;
	Sleep(1000);
}