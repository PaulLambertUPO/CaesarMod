// void, Obj me

Unit this;
point pt, ptCenter;
ObjList ol;
int i;
rect rcMap;

this = me.AsUnit;

rcMap = GetMapRect;

pt = .GetDir;
pt.SetLen(15 + rand(50));
pt.Rot(rand(180));
while(!pt.InRect(rcMap) || !IsPassable3x3(pt))
{
	pt.SetLen(15 + rand(50));
	pt.Rot(rand(180));
	pt = .pos + pt;
	Sleep(1000);
}
.Face(pt);
.SetSpeedFactor(7);
.SetWalkAnim(13);
while(!.Goto(pt, 0, 2000, true, 0)&& .HasPath)
{
	ol = ObjsInSight(this, "Wolf,Building,Unit,LionF,LionM,Boar").GetObjList;
	if(ol.count > 0)
	{
		ptCenter = ol[0].pos;
		for(i = 1; i < ol.count; i += 1)
		{
			ptCenter = ptCenter + ol[i].pos;
		}
		ptCenter = ptCenter / ol.count;
		ptCenter = .pos - ptCenter;
		ptCenter.Rot(rand(30)-15); 
		ptCenter.SetLen(.sight*2);
		ptCenter = .pos + ptCenter;
		.SetWalkAnim(1);
		.SetSpeedFactor(170);
		.AddCommand(true, "move", .ClipDestToMap(ptCenter));
		return;
	}
};
.Heal(.maxhealth/6);
.SetSpeedFactor(150);
.SetWalkAnim(1);


pt = .GetDir;
pt.SetLen(rand(150)+ 225);
pt = .pos + pt;

while(!pt.InRect(rcMap) || !IsPassable3x3(pt))
{
	pt.SetLen(rand(150)+ 225);
	pt.Rot(rand(180));
	Sleep(1000);
	pt = .pos + pt;
}

while(!.Goto(pt, 0, 2000, true, 0) && .HasPath);
{
	ol = ObjsInSight(this, "Wolf,Building,Unit,LionF,LionM,Boar").GetObjList;
	if(ol.count > 0)
	{
		ptCenter = ol[0].pos;
		for(i = 1; i < ol.count; i += 1)
		{
			ptCenter = ptCenter + ol[i].pos;
		}
		ptCenter = ptCenter / ol.count;
		ptCenter = .pos - ptCenter;
		ptCenter.Rot(rand(30)-15); 
		ptCenter.SetLen(.sight*2);
		ptCenter = .pos + ptCenter;
		.SetWalkAnim(1);
		.SetSpeedFactor(170);
		.AddCommand(true, "move", .ClipDestToMap(ptCenter));
		return;
	}
}