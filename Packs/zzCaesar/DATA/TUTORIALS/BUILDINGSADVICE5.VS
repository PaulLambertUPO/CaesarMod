//void, int playerid

//this script shows a hint about siege weapons

ObjList enemy_gates;
IntArray enemy_gates_status, enemy_health;
Obj obj;
int i;

Sleep(300000);

enemy_gates = EnemyObjs(playerid, cGate).GetObjList();
for (i = 0; i < enemy_gates.count; i += 1) {
	enemy_gates_status[i] = 0;
	enemy_health[i] = 0;
}

while (1) {
	Sleep(10000);
	for (i = 0; i < enemy_gates.count; i += 1) {
		obj = enemy_gates[i];
		if (obj.AsGate().AreEnemiesAround()) {//if allied units are near an enemy gate
			if (enemy_gates_status[i] == 0) {
				enemy_gates_status[i] += 1;
				enemy_health[i] = obj.health;
			}
			else if (obj.health >= enemy_health[i])
				enemy_gates_status[i] += 1;
			else
				enemy_gates_status[i] = 0;
		}
		if (enemy_gates_status[i] > 1) {//show hint only from the second time an enemy gate is detected with health not decreasing
			ShowHint(
				Translate("Siege weapons"),
				Translate("In order to break an enemy gate you need to attack it with ranged units or with a siege weapon (catapult, ram, tower). In order to create a siege weapon, select up to 10 warriors and order them to build it from the menu, then select the area by clicking on the appropriate place (make sure to build it in effective range). The more units are used to build a siege weapon, the faster the construction process and the attack speed will be."),
				obj
			);
			return;
		}
	}
}