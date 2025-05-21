//void, Obj attached

if (!attached.AsUnit().InHolder()) {
	owner.Heal(5);
	if (rand(10) == 0) {
		Unit u;
		u = Place("GGhost", attached.pos, attached.player);
		u.SetStamina(5);
		u.SetLevel(attached.AsUnit().level);
		u.SetCommand("spawn");
		SwapSelectedObj(attached, u);
	}
}