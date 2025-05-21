//void, Obj This

Building this;
ObjList l, p;
point pt;
int i, nOldPlayer, max;
Query ProtectiveArea;
Query Alert;
int traverse_ptr;
Unit u;

Query q1, q2, q3, q4;
Query cq1, cq2, cq3;
Query in, out;

this = This.AsBuilding();

nOldPlayer = -1; //important for query init below

Sleep(rand(1000) + 500);

if(!.IsValid()) {
	Sleep(10000);//will restart after 10 seconds
	return;
}

traverse_ptr = 0;
while(true)
{
	if (.player != nOldPlayer)
	{
		//recalc the query, .player has changed! (or first-time run)
		out = ObjsInSight(this,"Unit");
		in = UnitsInSettlement(.settlement, "Unit");
		ProtectiveArea = Union(in, out);
		
                //the Queries are well known among the script programmers as being very broken :)
                //don't try to rewrite these, as you may break something!!! (sometimes complex expressions
                //with queries don't behave correctly

		q1 = EnemyObjs(.player(), "Unit");
		q2 = EnemyObjs(.player(), "Animal");
		q3 = EnemyObjs(.player(), "Peaceful");
		q4 = EnemyObjs(.player(), "BaseMage");
		

		cq1 = Intersect(ProtectiveArea, q1);
		cq2 = Union(q2, q3);
		cq3 = Union(cq2, q4);
		Alert = Substract(cq1, cq3);

		nOldPlayer = .player; //to avoid multiple .player calls update this now
	}
	//wait enemies to come. Check from time to time if the player was changed
	while (nOldPlayer == .player())
	{
		WaitQueryCountBetween(Alert,1,-1,2000);
		l = Alert.GetObjList();
		if (l.count > 0)
			break;
	}

	//get all non-mine units out!
	pt = Point(.radius + 10,0);
	pt.Rot(rand(360));
	pt = pt + .pos;
	p = .settlement().Units();
	p.ClearDead();
	for (i = 0; i < p.count; i += 1)
	{
		u = p[i].AsUnit();
		if (!u.IsValid()) continue;
		if (!.IsEnemy(u)) continue;
		if (u.hero.IsValid()) continue;
		u.SetCommand("advance", pt);
	}

	//attack enemy
	if ((l.count()!=0) && (.settlement.loyalty < GetConst("LoyaltyUnitsOutTreshold")))
	{
		Unit u;
		int start_traverse;
		
		EnvWriteInt(.settlement, "EnemiesAlert", 1);
		
		pt = l[rand(l.count)].posRH();
		l = .settlement().Units();
		max = l.count();

		if (max) {
			p.Clear();
			traverse_ptr = traverse_ptr % max;
			start_traverse = traverse_ptr;
			for (i = 0; i < 50; i += 1) {
				u = l[traverse_ptr].AsUnit();
				if (u.IsValid) if(!u.hero.IsValid()) {
					p.Add(u);
				}
				traverse_ptr = (traverse_ptr + 1) % max;
				if (start_traverse == traverse_ptr)
					break;
			}
			//Command Stack
			p.AddCommand(true,"enter",this);
			p.AddCommand(true,"advance",pt);
			p.KillCommand();
		}
		Sleep(500);
		continue;
	}
	EnvWriteInt(.settlement, "EnemiesAlert", 0);
	Sleep(1000);
}
