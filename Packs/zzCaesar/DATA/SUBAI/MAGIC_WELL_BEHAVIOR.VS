//void, Obj This

ObjList l;
Unit u;

Sleep(rand(501) + 500);

while (1) {
	Sleep(500);
	l = Union(ObjsInRange(This, "Military", 400), ObjsInRange(This, "Peaceful", 400)).GetObjList();//exclude animals
	if (l.count > 0) {
		l.ClearDead();
		l = l.ObjInjured();
		if (l.count > 0) {
			u = l[rand(l.count)].AsUnit();
			if (u.IsValid) {
				u.Heal(100);
				CreateFeedback("Heal", u);
			}
			Sleep(500);
		}
	}
}