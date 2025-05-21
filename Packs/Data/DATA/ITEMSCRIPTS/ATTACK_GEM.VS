//void, Obj owner

Hero this;
ObjList army, army_added;
int i;

this = owner.AsHero();
if (!.IsValid)
	return;

army = .army;
for (i=0; i<army.count; i+=1)
	army[i].AsUnit.AddBonus(4,0,0,0,0);
army_added = army;

while (true) {
	Sleep(10);

	for (i=0; i<army.count; i+=1)
		if (army[i].AsUnit.hero != this)
			army[i].AsUnit.RemoveBonus(4,0,0,0,0);
	
	army = .army;
	for (i=0; i<army.count; i+=1)
		if(!army_added.Contains(army[i]))
			army[i].AsUnit.AddBonus(4,0,0,0,0);

	army_added = army;
}