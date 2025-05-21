// void, Obj This, point pt
Hero this;
point dpt;

//.pr("hero::move");
this = This.AsHero();

if(.IsValid() == false)
{
	return;
}
if(.InShip() == true)
{
	Ship s;
	s = .GetShip();
	
	if(s.IsValid() == true && s.IsAlive() == true)
	{
		if(s.player() != .player() && DiplGetShareControl(s.player(), .player()) == false)
		{
			s.SetCommand("unboardall", s.pos());
			return;
		}	//Fine if.
	}	//Fine if.
	else
	{
		return;
	}	//Fine else.
}	//Fine if.

// Ivko: Always walk in formation, so newly attached units automatically enter formation
.FormSetupAndMoveTo (pt, 0, 0, true);
while (.HasPath ())
{
  .FormKeepMoving (1500);
}

dpt = .GetFinalPartyOrientation() - Point(1024, 1024);
if (dpt.x != 0 || dpt.y != 0)
	.Face(.pos + dpt);

if (.IsAlive)
if (.HasArmy)
if (.CmdCount == 1)
{
	.army.SetCommand("stand_position");
	.AddCommand(false, "stand_position");
}
