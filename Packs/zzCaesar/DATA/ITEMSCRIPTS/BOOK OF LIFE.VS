//void, Obj owner, Obj attached, Obj victim

if (victim.AsUnit().IsValid)
	if (owner.AsHero().IsValid) {
		Unit this;

		this = attached.AsUnit();

		if (.IsValid)
			if (!.AsHero().IsValid) {//this script seems to be triggered even when the owner kills a unit
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