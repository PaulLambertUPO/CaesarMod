// void, Obj This, point pt


Druid this;
Unit tgt;
int  time, retries, try;
int level;

this = This.AsDruid;

time = GetConst("RetryWait");
retries = GetConst("RetryCount");

if (EnvReadString(.player, "Ancestral Knowledge") == "researched") {
	level = 10;
}
else {
	level = 4;
}

tgt = .FindUnitBelowILevel(level);
while (!.Goto(pt, 0, 2000, true, -1))
	{
		if(tgt.IsValid)
		if(.DistTo(pt) < .sight)
			break;
		tgt = .FindUnitBelowILevel(level);
		if (.TimeWithoutWalking() > 2500) break;
	}

if(!tgt.IsValid)
{
	tgt = .FindUnitBelowILevel(level);
	while (try < retries && !tgt.IsValid()) {
		Sleep(time);
		tgt = .FindUnitBelowILevel(level);
		try += 1;
	}
}
if(tgt.IsValid) {
	.AddCommand(true, "advance", pt);
	.AddCommand(true, "teach", tgt);
}
