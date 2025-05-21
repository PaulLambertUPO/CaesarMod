// void, Obj This,Obj bld

Unit this;
point pt;   
Building building;
bool error;
bool bEnterCatapult;

this = This.AsUnit();
if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

building = bld.AsBuilding();

if (!building.IsValid() )
	{ Sleep(10); return; }

if( .IsEnemy(building) && !building.AsTeleport.IsValid) 
	{ Sleep(10); return; }

if( !building.settlement.IsValid )
	{ Sleep(10); return; }

if (building.settlement.max_units==0)
	{ Sleep(10); return; }

if( !.AsHero.IsValid && building.IsHeirOf("BaseRuins")) 
	{ Sleep(10); return; }

bEnterCatapult = building.IsHeirOf( "Catapult" );

if( ! bEnterCatapult ) 
	.SetEntering(true);
else
	if(.hero.IsValid) 
		.DetachFrom(.hero);

if (!building.settlement.Units().Contains(this))
{
    pt = building.GetEnterPoint(this);
    //.pr("unit::enter: going");
	if( bEnterCatapult )
	{
		while(!.Goto(pt, 0, 1000, true, 5000));
	}
	else
	{
	    while(!.GotoEnter(pt, 0, 1000, true, 5000));
	}

    //.pr("unit::enter: entering");
	{	bool bStop=false;
		if (building.IsDead() && !bEnterCatapult) {
			bStop = true;
		} else if( building.IsDead() && bEnterCatapult ) {
			.Goto(pt, 200, 1000, true, 5000);
			return;
		} else if ( (this.IsEnemy(building) && !building.AsTeleport().IsValid()) ||
					building.settlement.max_units==0) {
			bStop = true;
		}
		if (bStop) {
			.Stop(10000); 
			.SetEntering(false); 
			return;
		}
	}
	if(.IsValid() == true) // leave parry mode at new command
		.SetParryMode(false);
	building.settlement.AddUnit(this);
}

if( ! bEnterCatapult ) 
	.SetEntering(false);
