ObjList ol;
Obj shipyard;
str ship_name;
int i, j, ship_interval;

ship_interval = 600000 - GetDifficulty() * 120000;

while (1) {
	Sleep(ship_interval);
	for (i = 1; i <= 3; i += 1) {
		shipyard = GetNamedObj("Sh_" + i);
		ship_name = "T_Ships" + i;
		if (shipyard.player == 1)
			Group(ship_name).Damage(5000);
		else if (shipyard.health > shipyard.maxhealth / 5) {
			ol = SpawnGroup(ship_name);
			Group(ship_name).SetPlayer(shipyard.player);
			for (j = 0; j < ol.count; j += 1)
				SpawnGroupInHolder("T_RGroup" + (rand(7) + 1), ol[j]).SetPlayer(shipyard.player);
		}
	}
}