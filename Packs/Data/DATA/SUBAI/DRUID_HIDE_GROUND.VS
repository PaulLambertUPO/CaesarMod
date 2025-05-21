// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries;
int	 timeStart;

this = This.AsDruid;
if (!.IsAlive) return;
if (!.HasSpecial(invisibility)) return;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

timeStart = GetTime();

tgt = .FindUnitToHide;
while (!.Goto(pt, 0, 2000, true, -1))
{
	if (tgt.IsValid) if (tgt.IsVisible)	if (.DistTo(pt) < .sight)
		break;
	tgt = .FindUnitToHide;
	if (.TimeWithoutWalking() > 2500)
		break;
}
while (!tgt.IsValid && retries > 0)
{
	Sleep(time);
	tgt = .FindUnitToHide;
	retries -= 1;
}
if (.IsAlive) if (tgt.IsValid)
{
	if (timeStart == GetTime())
		Sleep(131);
	.AddCommand(true, "hide", pt);
	.AddCommand(true, "hide", tgt);
}
