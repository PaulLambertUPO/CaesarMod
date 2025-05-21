// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries;

this = This.AsDruid;
if (!.IsAlive) return;
if (!.HasSpecial(revitalize)) return;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

tgt = .FindUnitToRevitalize;
while (!.Goto(pt, 0, 2000, true, -1))
{
	if (tgt.IsValid) if (.DistTo(pt) < .sight)
		break;
	tgt = .FindUnitToRevitalize;
	if (.TimeWithoutWalking() > 2500)
		break;
}
while (!tgt.IsValid && retries > 0)
{
	Sleep(time);
	tgt = .FindUnitToRevitalize;
	retries -= 1;
}
if (tgt.IsAlive) if (.IsAlive)
{
	.AddCommand(true, "revitalize", pt);
	.AddCommand(true, "revitalize", tgt);
}
