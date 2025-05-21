// void, Obj This 

Building bld;
Settlement this;


bld = This.AsBuilding();
if (bld.IsValid) 
{
	this = bld.settlement;
	if (.IsValid) 
	{
		ObjList l;
		int i;
		Unit u;
		int nHealth, nGive;
        
		nHealth = 2000;
		nGive   = 0;
		l = .ObjectsAround("Military");
		l.AddList(.ObjectsAround("BaseMage"));
		for (i = l.count; i > 0;) 
		{
			i -= 1;
			u = l[i].AsUnit();
			if (!bld.IsEnemy(u)) 
				if (u.health < u.maxhealth) 
				{
					CreateFeedback("Heal", u);
					nGive = u.maxhealth - u.health;
					if (nGive > nHealth) nGive = nHealth;
					nHealth -= nGive;
					u.Heal(nGive);
					if (nHealth == 0) break;
				}
		}	
	}
}