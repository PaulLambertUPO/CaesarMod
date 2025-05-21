//void, Obj owner

Unit this;
ObjList army;

this = owner.AsHero;
if (!.IsValid) return;

while (true)
{
	int i;
	Sleep(4570);
	army = .AsHero.army;
	for (i=0; i<army.count; i+=1)
		army[i].HealStamina(1);
}
