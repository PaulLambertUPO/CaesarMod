// void, Obj This, Obj obj

Unit  this;
Ship  ship;
ObjList ol;

this = This.AsUnit;
ship = obj.AsShip;

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

if( ship.IsValid() == true) 
{
	ol = ship.GetUnitsOnBoard;
	if(ol.Contains(this) == false) 
	{
		//La nave si avvicina all'unità solo se appartengono allo stesso giocatore o solo se sono alleati con "condividi controllo" attivo:
		if(ship.player() == .player() || DiplGetShareControl(ship.player(), .player()) == true)
		{
			ship.NotifyBoardUnit(this);
		}	//Fine if.
		else
		{
			.AddCommand(false, "boardship", obj);
		}	//Fine else.
		
		.AddCommand(true, "boardshipcommon", obj);
	}
}