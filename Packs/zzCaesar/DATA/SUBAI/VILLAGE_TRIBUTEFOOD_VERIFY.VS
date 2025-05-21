//bool, Obj this, Obj other

//adding a condition with this != other is not wrong, but forces the player to use 'stop tribute' (bad user experience)

if (.AsBuilding().IsValid)
	if (other.AsBuilding().IsValid)
		if (DiplGetShareSupport(.player, other.player))
			return true;

return false;