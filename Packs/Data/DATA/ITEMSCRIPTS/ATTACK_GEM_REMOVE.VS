//void, Obj owner

Unit this;
ObjList army;
int i;

this = owner.AsHero;
if (!.IsValid) return;

army = .AsHero.army;
for (i=0; i<army.count; i+=1)
	army[i].AsUnit.RemoveBonus(4,0,0,0,0);