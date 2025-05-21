// void, Obj This, point pt

Druid this;
Unit tgt;
int  time, retries, try;

this = This.AsDruid;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

tgt = .GetBestCrippleTarget.AsUnit;
if (!tgt.IsAlive)
	while (!.Goto(pt, 0, 2000, true, -1))
	{
		tgt = .GetBestCrippleTarget.AsUnit;
		if (tgt.IsAlive) break;
		if (.TimeWithoutWalking() > 2500) break;
	}

if (!tgt.IsAlive)
{
	tgt = .GetBestCrippleTarget.AsUnit;
	while (try < retries && !tgt.IsAlive)
	{
		Sleep(time);
		tgt = .GetBestCrippleTarget.AsUnit;
		try += 1;
	}
}
if (tgt.IsAlive)
{
	.AddCommand(true, "advance", pt);
	.AddCommand(true, "cripple", tgt);
}
