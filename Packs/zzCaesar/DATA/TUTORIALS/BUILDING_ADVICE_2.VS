//void, int playerid

//this script shows a hint about siege machines

ObjList enemy_gates;
IntArray enemy_gates_status, enemy_health;
Obj o;
int i, j;

Sleep(300000);

enemy_gates = EnemyObjs(playerid, cGate).GetObjList();
for (i = enemy_gates.count - 1; i >= 0; i -= 1) {
	enemy_gates_status[j] = 0;
	enemy_health[j] = 0;
	j += 1;
}

if (j > 0)
	while (true) {
		Sleep(10000);
		for (i = 0; i < j; i += 1) {
			o = enemy_gates[i];
			if (o.AsGate().AreEnemiesAround)//if allied units are near an enemy gate
				if (enemy_gates_status[i] == 0) {
					enemy_gates_status[i] += 1;
					enemy_health[i] = o.health;
				}
				else if (o.health >= enemy_health[i])
					enemy_gates_status[i] += 1;
				else
					enemy_gates_status[i] = 0;
			if (enemy_gates_status[i] > 1) {//show hint only from the second time an enemy gate is detected with health not decreasing
				ShowTutorial(
					Translate("Siege machines"),
					Translate("In order to break an enemy gate you need to attack it with ranged units or with a siege machine (catapult, ram, tower). In order to create a siege machine, select up to 10 warriors and order them to build it from the menu, then select the area by clicking on the appropriate place (make sure to build it in effective range). The more units are used to build a siege machine, the faster the construction process and the attack speed will be."),
					o
				);
				return;
			}
		}
	}