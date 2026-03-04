//void, Obj this

int duration = 10000;

while (duration > 0) {
	RevealHiddenEnemyUnits(.pos, .sight, .player);
	Sleep(1000);
	duration -= 1000;
}

.Damage(.health);