// void, Obj me, Obj tgt

	Unit this;
	point ptCenter;
	Obj u;
	Query qEnemy;
	int i;
	ObjList ol;
	this = me.AsUnit;
	u = tgt.AsUnit();
	if(u.IsAlive())	
	{
		while (u.IsAlive()) 
		{
			 if(!.IsValidTarget(u)) break;

			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				if(!u.IsAlive() || !.IsValidTarget(u)) break;
				if(.health < .maxhealth/2) // I'm sooooo scared 
				{
					qEnemy = Intersect(Union(ObjsInSight(this, "Military"), ObjsInSight(this, "Tower")), EnemyObjs(.player, "Military"));
					ol = qEnemy.GetObjList();
					if(ol.count > 0)
					{
						ptCenter = ol[0].pos;
						for(i = 1; i < ol.count; i += 1)
						{
							ptCenter = ptCenter + ol[i].pos;
						}
						ptCenter = ptCenter / ol.count;
						ptCenter = .pos - ptCenter; 
						ptCenter.SetLen(.sight*3);
						.AddCommand(true, "move", ptCenter);
						return;
					}
				}
			}
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u));
			}
		}
	} 
