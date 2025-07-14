//void, Obj owner, Obj attached

if (owner.AsHero().IsValid) {
	Unit this;

	this = attached.AsUnit();

	if (.IsValid)
		if (!.AsHero().IsValid)//it seems that the script is triggered even when the owner kills a unit
			if (!.InHolder) {
				owner.Heal(5);
				if (rand(10) == 0) {
					Unit u;
					u = Place("GGhost", victim.pos, .player);
					u.SetStamina(5);
					u.SetLevel(.level);
					u.SetCommand("spawn");
					SwapSelectedObj(victim, u);
				}
			}
}