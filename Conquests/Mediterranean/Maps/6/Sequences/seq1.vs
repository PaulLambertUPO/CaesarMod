ObjList units_to_disease;
Unit u;
int i, j;

while (1) {
	for (i = 1; i <= 5; i += 1) {
		units_to_disease = ClassPlayerAreaObjs(cUnit, 1, "A_Disease" + i).GetObjList();
		units_to_disease.ClearDead();
		for (j = 0; j < units_to_disease.count; j += 1) {
			u = units_to_disease[j].AsUnit();
			if (u.IsValid)
				if (!u.IsDiseased())
					u.Disease();
		}
	}
	Sleep(1000);
}