//void, Obj This

ObjList damaged_units;
Obj o;
point pt_pos;

Sleep(500 + rand(501));

pt_pos = This.pos;

while (1) {
	damaged_units = ObjsInCircle(pt_pos, 400, "Military,Peaceful").GetObjList().ObjInjured();
	if (damaged_units.count > 0) {
		o = damaged_units[rand(damaged_units.count)];
		if (o.IsAlive) {
			o.Heal(100);
			CreateFeedback("Heal", o.AsUnit());
		}
	}
	Sleep(1000);
}