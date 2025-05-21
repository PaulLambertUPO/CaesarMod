// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries;
int	 timeStart;

this = This.AsDruid;
if (!.IsAlive)             return;
if (!.HasSpecial(healing)) return;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

timeStart = GetTime();

tgt = .FindUnitToHeal;
while (!.Goto(pt, 0, 2000, true, -1))
{
	if (tgt.IsValid) if (.DistTo(pt) < .sight)
		break;
	tgt = .FindUnitToHeal;
	if (.TimeWithoutWalking() > 2500)
		break;
}
while (!tgt.IsValid && retries > 0)
{
	Sleep(time);
	tgt = .FindUnitToHeal;
	retries -= 1;
}
if (tgt.IsAlive) if (.IsAlive)
{
	if (timeStart == GetTime())
		Sleep(75);
	.AddCommand(true, "heal", pt);
	.AddCommand(true, "heal", tgt);
}
