// void, Obj This, Obj obj

Hero  this;
Ship  ship;
bool  bThere;

this = This.AsHero;
ship = obj.AsShip;

if (.IsValid() == false || ship.IsValid() == false)
{
	return;
}	//Fine if.

//La nave si avvicina all'eroe solo se appartengono allo stesso giocatore o solo se sono alleati con "condividi controllo" attivo:
if(ship.player() == .player() || DiplGetShareControl(ship.player(), .player()) == true)
{
	ship.NotifyBoardUnit(this);
}	//Fine if.
else
{
	.AddCommand(false, "boardshiphero", ship);
}	//Fine else.

if( Dist( ship.pos, .pos ) > 700 )
{
	.FormSetupAndMoveTo( ship, 0, 0, false );
	while( .HasPath() && Dist( ship.pos, .pos ) > 700 )
	{
		.FormKeepMoving( 1500 );
	}
}
.army.SetCommand( "boardship", ship );
.AddCommand( true, "boardshipcommon", ship );