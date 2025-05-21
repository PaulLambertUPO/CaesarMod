//void, Obj This

Settlement this;
Wagon wagon;
point p;

this = This.AsBuilding().settlement;

wagon = .CreateMuleGold(1000);

if (wagon.IsValid) {
	ClearSelection(wagon.player);
	wagon.Select(wagon.player);
	p.Set(This.radius, This.radius);
	wagon.AddCommand(false, "move", This.pos + p);
	wagon.KillCommand();
}