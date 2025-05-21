// void, Obj This

Settlement this;
Wagon      wagon;
point      ptGo;

this = This.AsBuilding().settlement;

wagon = .CreateBoatFood( 250 );
if( wagon.IsValid )
{
	ClearSelection( wagon.player );
	wagon.Select( wagon.player );
	ptGo = .GetCentralBuilding.GetExitVector();
	ptGo.Set( ptGo.x * 5, ptGo.y * 5 );
	wagon.AddCommand( false, "move", This.pos + ptGo );
	wagon.KillCommand();
}
