//void, Obj owner, Obj attached

if (owner.AsHero().IsValid) {
	Unit this;

	this = attached.AsUnit();

	if (.IsValid) {
		owner.Heal(5);
		if (rand(10) == 0)
			if (!.InHolder) {
				Unit u;
				u = Place("GGhost", .pos, .player);
				u.SetStamina(5);
				u.SetLevel(.level);
				u.SetCommand("spawn");
				SwapSelectedObj(this, u);
			}
	}
}