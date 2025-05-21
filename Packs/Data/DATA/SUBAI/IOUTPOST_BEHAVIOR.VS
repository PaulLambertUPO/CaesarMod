//void, Obj This

Building this;
ObjList ol;
int i;
int nSleepTime;
Unit u;

nSleepTime = GetConst("IOutpostExpTick");

this = This.AsBuilding();

Sleep(rand(nSleepTime) + 1000);

while(1)
{
	ol = .settlement.Units;
	for (i = 0; i < ol.count; i += 1)
	{
		u = ol[i].AsUnit;
		if (!u.IsValid) continue;
		if (.IsEnemy(u)) continue;
		if (u.inherentlevel >= 8) continue;
		u.SetExperience(u.experience + 1);
	}
	Sleep(nSleepTime);
}
