//void, Obj This

//this script manages the capture of an outpost (when taken, enemy units inside exit)

Building this;
ObjList list;
Unit u;
point pt;
int i;

this = This.AsBuilding();

Sleep(rand(2000) + 500);

if (!.IsValid()) {
	Sleep(10000);//will restart after 10 seconds
	return;
}

while (true)
{
	pt = Point(.radius + 25, 0);
	pt.Rot(rand(360));
	pt = pt + .pos;
	list = .settlement().Units().ObjEnemy(.player);
	list.ClearDead();
	list.SetCommand("advance", pt);
	Sleep(2371);
}
