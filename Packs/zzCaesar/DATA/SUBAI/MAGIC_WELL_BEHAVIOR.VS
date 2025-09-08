//void, Obj This

ObjList damaged_units;
Unit u;
point pos;

Sleep(rand(501) + 500);

pos = This.pos;

while (1) {
	damaged_units = ObjsInCircle(pos, 400, "Military,Peaceful").GetObjList().ObjInjured();//exclude animals
	if (damaged_units.count > 0) {
		u = damaged_units[rand(damaged_units.count)].AsUnit();
		if (u.IsValid) {
			u.Heal(100);
			CreateFeedback("Heal", u);
		}
	}
	Sleep(1000);
}