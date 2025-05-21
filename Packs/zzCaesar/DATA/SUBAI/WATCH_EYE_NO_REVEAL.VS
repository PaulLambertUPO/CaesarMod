//void, Obj this

int duration;

duration = GetConst("ScoutAreaDuration");

while (duration > 0) {
	Sleep(1000);
	duration -= 1000;
}

.Damage(.health);