//void, Obj This

/*
the class entity file contains both 5 and 1188 (index and base duration of the attack animation, which can also be taken with GetAnimTime(5))
as the speed factor rises, the time decreases but not linearly so subtracting values is not possible and the direct assignment is the best solution
example with 50% speed_factor --> attack_time_ms = 1_attack / (attack_with_speed_factor / base_attack_duration_sec) * 1000  -->  1 / (1.5 / 1.188) * 1000
*/

Unit this;
ObjList ol;
int attack_time, i;

this = This.AsUnit();

while (.HasSpecial(trample)) {//just a security check in case the special is removed from the class
	while (.GetAnim() == 5) {
		ol = Intersect(EnemyObjs(.player, "Catapult"), ObjsInCircle(.pos, 130, "Catapult")).GetObjList();
		if (ol.count > 0) {
			//example values: 594 (100 s_f, standard), 540 (110 s_f, God's Gift), 424 (140 s_f, Charm of Athena), 396 (150 s_f, both items)
			attack_time = Int(1 / (.speed_factor / 100.0 / 1.188) * 500);

			Sleep(attack_time);//before the hit

			if (.IsAlive)//elephant might have died just before completing the attack animation
				for (i = 0; i < ol.count; i += 1)
					ol[i].Damage(.damage);

			Sleep(attack_time);//after the hit
		}
	}
	Sleep(150);
}

Sleep(500);