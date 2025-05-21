//void, Obj This

Settlement set;

set = This.AsBuilding().settlement;

if (This.AsBuilding.race!=ImperialRome)
   return;

// Religious feast
if (EnvReadString(set, "Religious Feast")=="researched")
{
	ObjList l;
	int i;
	Unit u;
    int units2heal;
    int health;
    int idx,rnd;
    
    units2heal = 5;// choose that count units nad heal them with that health
    health     = 30;
	
	l = set.ObjectsAround("Military");
	
	// Remove enemies, sentries, and not damaged unit from list
	i = l.count;
	while (i > 0)
	 {
		i -= 1;
		u = l[i].AsUnit();
		if (This.IsEnemy(u) || u.health == u.maxhealth) 
		  l.Remove(u);	
	 }
	// Choose 5 random units and heal them;
	
	rnd = l.count/units2heal;
	if (rnd<=0)// l.count<units2heal=> heal all units
	  {
		for (i=0; i<l.count; i+=1)
		  {
			u = l[i].AsUnit();
			if (u.IsAlive)
			  {
				int damage;
				CreateFeedback("Heal", u);
				damage = u.maxhealth - u.health;
				if (damage>health) 
				  damage = health;
				u.Heal(damage);
			  }
		  }		  
	  }
	else
	{
	  for (i=0; i<units2heal; i+=1)
	    {
		  // choose a unit
		  idx = i*rnd + rand(rnd); 
		  // heal it
			u = l[idx].AsUnit();
			if (u.IsAlive)
			  {
				int damage;
				CreateFeedback("Heal", u);
				damage = u.maxhealth - u.health;
				if (damage>health) 
				  damage = health;
				u.Heal(damage);
			  }
	    }	
    }		
}


Sleep(2000);