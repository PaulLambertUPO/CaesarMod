// void, Obj This

Unit this, u;
int i,rnd;
point pt, ptDir;
Query qNewDestTowers, qWolves;
Obj attacker, target;
ObjList ol;
bool bFleeing;
rect rcMap;
this = This.AsUnit();
bFleeing = false;
this = This.AsUnit();

//pr("hero::move: defensive move - attack if attacked");
rcMap = GetMapRect;
while(!.Stop(1000));
.Idle(700);
ptDir = .GetDir;
while(1)
{
	rnd = rand(30);
	if((pt.x==0 && pt.y==0 )|| ((!bFleeing && rnd== 0) || (bFleeing && rnd!=0)))
	{
		ptDir.SetLen(.sight + rand(.sight/4));
		ptDir.Rot(rand(15)+15);
		pt = ptDir +.pos; 
		if(!pt.InRect(rcMap) || !IsPassable3x3(pt))
		{
			Sleep(100); // instruction limit gets exceeded here, probably not the best solution
			continue;
		}
	}
	Sleep(100); // instruction limit gets exceeded here, probably not the best solution
	if(rnd!= 0)
	{
		qNewDestTowers = Intersect(ObjsInCircle(pt, .sight, "TTent,Tower,Military"), EnemyObjs(.player, "Object"));
												
		if(qNewDestTowers.count > 0)
		{
			//pr("ooops! think, think, think what shall we do now? just saw a " + qNewDestTowers.GetObjList[0].class);
			.Idle(700); 
			continue;
		}
		if(rand(3) == 0)
		{
			ol = ObjsInCircle(pt, .sight, "Building").GetObjList;
			if(ol.count != 0)
			{
				ptDir = .pos - ol[0].pos;
				continue;
			}
		}
		if(IsPointInWater(pt))
		{
			ptDir = .pos - pt;
			continue;
		}
	} 
	
	if(Intersect(ObjsInSight(this, "BaseVillage,Unit,Tower"), EnemyObjs(.player, "Object")).count == 0 )
	{
		for(i = 0; i < 16; i+=1)
		{
			attacker = .BestTargetInSquadSight();
			if(attacker.IsAlive())
			{
				if(attacker.attack > 1)
				{
					ptDir = .pos - attacker.pos;
					bFleeing = true;
					break; 
				} else
				if(.health < .maxhealth) // i'm really angry grrrr!!!
				{
					.AddCommand(true, "engage");
					return;
				}
			}
			while(!.Stop(1000));
			.Idle(2000);	
		}
		if(attacker.IsAlive())
			continue;
	}
	ol = Intersect(Intersect(ObjsInCircle(.pos, .sight * 2, "LionM, LionF"), FriendlyObjs(.player, "LionM")),FriendlyObjs(.player, "LionF")).GetObjList();
	while(!.Goto(pt, 0, 1000, true, 0) && .HasPath)
	{
		attacker = .BestTargetInSquadSight();
		if(attacker.IsAlive() && !bFleeing)
		{
			if(attacker.DistTo(this) < .sight/4 || .health < .maxhealth)
			{
				.AddCommand(true, "engage");
				return;
			} else
			{
				ptDir = .pos - attacker.pos;
				bFleeing = true;
				break; 
			}
		}
	}
	bFleeing = false;
}