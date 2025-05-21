// void, Obj me

	Unit this;
	point ptCenter;
	Obj u;
	Query qEnemy, qWolves;
	int i, noattacktime;
	ObjList ol;
	bool bImSoScared;

	bImSoScared = false;
	this = me.AsUnit();
	//pr("advance: searching for new enemy");
	u = .BestTargetInSquadSight();
	noattacktime = 0;
	if(u.IsAlive())	
	{
		//pr("advance: target found!");
		while (u.AsUnit.IsAlive())
		{
			if(u.AsUnit.InHolder)
				break;
			 if(!.IsValidTarget(u)) break;
		
			while(!.GotoAttack(u, 1500, true, -1)) 
			{
				noattacktime += 1;
				if((noattacktime >= 2 && .attack > 1) ||
					noattacktime >= 3)
					bImSoScared = true;
				//pr("advance: approaching target!");
				u = .BestTargetInSquadSight();
				if(!u.IsAlive())
					break;
				else
				 if(!.IsValidTarget(u)) break;
			}
			//pr("advance: attacking target!");
			if (u.IsAlive() && .IsValidTarget(u))
			{
				while (.Attack(u))
				{
					if(.health < 2*.maxhealth/3)
					{
						if(Intersect(ObjsInSight(this, "Tower"), EnemyObjs(.player, "Tower")).count > 0 && u.attack <= 1)
						{
							bImSoScared = true;;
							break;
						}
					}
					
				}
				noattacktime = 0;
			}
			if(bImSoScared) // I'm sooooo scared 
			{
				qEnemy = Intersect(ObjsInSight(this, "Military,Tower"), EnemyObjs(.player, "Object"));
				ol = qEnemy.GetObjList();
				if(ol.count > 0)
				{
					ptCenter = ol[0].pos;
					for(i = 1; i < ol.count; i += 1)
					{
						ptCenter = ptCenter + ol[i].pos;
					}
					ptCenter = ptCenter / ol.count;
					ptCenter = ptCenter - .pos; 
					ptCenter.SetLen(.sight*3);
					ptCenter = .pos - ptCenter;
					ptCenter = ptCenter.ClampToMap();
					qWolves = Intersect(ObjsInCircle(.pos, .sight*2, "LionF,LionM"), FriendlyObjs(.player, "LionM"));
					qWolves = Intersect(qWolves, FriendlyObjs(.player, "LionF"));
					ol = qWolves.GetObjList;
					if (.IsValid)
					if (ol.Contains(this))
						ol.Remove(this);
					ol.SetCommandOffset("move", ptCenter);
					if (.IsAlive)
						.AddCommand(true, "move", ptCenter);
					return;
				}
			}
			u = .BestTargetInSquadSight();
		}
	} 
