//bool, Obj this, Obj other

Settlement sett;
ObjList blds;
int i;

sett = .AsBuilding().settlement();
blds = sett.Buildings();

if (sett.IsIndependent())
	return false;
if (sett.UnitsCount() == 0) 
	return false;

if (other.AsUnit().IsAlive()) 
{
	if (!.IsEnemy(other))
		return false;

	for (i = 0; i < blds.count; i += 1) 
	{
		Tower w;
		w = blds[i].AsTower();
		if (w.IsValid()) 
		{
			if (w.IsHeirOf("FakeTower")) 
			{
				if (w.CanAttack(other))
					return true;
			}
		}
	}
}
return false;