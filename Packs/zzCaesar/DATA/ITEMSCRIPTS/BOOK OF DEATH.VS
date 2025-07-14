//void, Obj owner, Obj attached

if (owner.AsHero().IsValid) {
	Unit this;

	this = attached.AsUnit();

	if (.IsValid)
		if (!.InHolder) {
			owner.Heal(5);
			if (rand(10) == 0) {
				Unit u;
				u = Place("GGhost", .pos, .player);
				u.SetStamina(5);
				u.SetLevel(.level);
				u.SetCommand("spawn");
				SwapSelectedObj(this, u);
			}
		}
}