// void, Obj me

Unit  this, u;
point pt;
int   range;
bool  bSleeped;

this = me.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

while( ! .Stop( 1 ));
pt = .posRH;
range = 120;

while(.IsAlive)
{
	if (.CmdCount() > 1)
		break;
	if( .IsRanged )
	{
		u = .BestTargetInRange( pt, .range );
		while( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
		{
			bSleeped = false;
			while( .Attack( u ))
			{
				if( ! .IsVisible ) break;
				bSleeped = true;
			}
			if( ! bSleeped ) Sleep( 50 );
			u = .BestTargetInRange( pt, .range );
		}
	}
	else
	{
		u = .BestTargetInRange( pt, range );
		while( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
		{
			bSleeped = false;
			while( ! .GotoAttack( u, 1500, true, 15000))
			{
				bSleeped = true;
				u = .BestTargetInRange( pt, range );
				if( !u.IsAlive || ! .IsValidTarget( u )) break;
				if( !.IsVisible ) break;
			}
			if( u.IsAlive && .IsValidTarget( u ) && .IsVisible)
			{
				while( .Attack( u ))
				{
					if( ! .IsVisible ) break;
					bSleeped = true;
				}
			}
			if( ! bSleeped ) Sleep( 50 );
			u = .BestTargetInRange( pt, range );
		}
	}
	if( ! u.IsAlive && ( pt.x != .posRH.x || pt.y != .posRH.y ))
	{
		while( ! .Goto( pt, 0, 100, false, -1 ));
	}
	else
		.Idle(1);
}
