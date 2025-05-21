ObjList ol;
Obj o;
str set_name;
int i, j;

for (i = 2; i <= 37; i += 1) {
	set_name = "S_Sett" + i;
	o = GetNamedObj("NO_" + i);
	if (o.IsHeirOf("BaseTownhall"))
		ol = SpawnGroupInHolder("T_" + set_name, set_name);
	else if (o.IsHeirOf("Outpost"))
		ol = SpawnGroupInHolder("T_" + set_name, set_name);
	else
		ol = SpawnGroup("T_" + set_name);
	for (j = 0; j < ol.count; j += 1)
		if (ol[j].AsHero().IsValid)
			ol[j].AsHero().SetAutocast(true);
}

RunSequence("Patrolers");