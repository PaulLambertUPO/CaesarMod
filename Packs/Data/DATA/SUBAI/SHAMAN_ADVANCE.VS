// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries, try, j;
ObjList ol;

this = This.AsDruid;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

//tgt = .GetBestCurseTarget(); //THIS SCRIPT DOESN'T WORK!
ol = Intersect( EnemyObjs(.player,"Unit") , VisibleObjsInSight(.AsUnit, "Military") ).GetObjList;
for(j=0; j<ol.count; j+=1) {
	if (ol[j].AsUnit.IsCursed)
		continue;
	if(ol[j].pos.Dist(.pos) <= tgt.pos.Dist(.pos) || !tgt.IsValid){
		tgt = ol[j].AsUnit();
	}
}

if (!tgt.IsAlive)
	while (!.Goto(pt, 0, 2000, true, -1))
	{
//		tgt = .GetBestCurseTarget();
		ol = Intersect( EnemyObjs(.player,"Unit") , VisibleObjsInSight(.AsUnit, "Military") ).GetObjList;
		for(j=0; j<ol.count; j+=1) {
			if (ol[j].AsUnit.IsCursed)
				continue;
			if(ol[j].pos.Dist(.pos) <= tgt.pos.Dist(.pos) || !tgt.IsValid){
				tgt = ol[j].AsUnit();
			}
		}
		if (tgt.IsAlive) break;
		if (.TimeWithoutWalking() > 2500) break;
	}

if (!tgt.IsAlive)
{
//	tgt = .GetBestCurseTarget();
	ol = Intersect( EnemyObjs(.player,"Unit") , VisibleObjsInSight(.AsUnit, "Military") ).GetObjList;
	for(j=0; j<ol.count; j+=1) {
		if (ol[j].AsUnit.IsCursed)
			continue;
		if(ol[j].pos.Dist(.pos) <= tgt.pos.Dist(.pos) || !tgt.IsValid){
			tgt = ol[j].AsUnit();
		}
	}
	while (try < retries && !tgt.IsAlive)
	{
		Sleep(time);
		tgt = .GetBestCurseTarget();
		try += 1;
	}
}
if (tgt.IsAlive)
{
	.AddCommand(true, "advance", pt);
	.AddCommand(true, "curse", tgt);
}
