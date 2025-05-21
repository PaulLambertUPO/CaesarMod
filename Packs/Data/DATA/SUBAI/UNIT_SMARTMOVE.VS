// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

if (!.BestTargetInSquadSight().IsAlive()) {
  //.pr("unit::move: advancing to position");
  .AddCommand(true, "advance", pt);
  return;
}

while (!.Goto(pt, 0, 2000, true, 0));
