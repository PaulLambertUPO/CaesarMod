ObjList player_sets;
Settlement set;
int i;

NO_Town1.obj.AsBuilding().Research("Learning");

while (1) {
	player_sets = ClassPlayerObjs(cBaseTownhall, 1).GetObjList();
	for (i = 0; i < player_sets.count; i += 1) {
		set = player_sets[i].AsBuilding().settlement;
		set.SetFood(set.food + 600);
	}
	Sleep(30000);
}