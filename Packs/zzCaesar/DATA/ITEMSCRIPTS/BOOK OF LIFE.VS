//void, Obj owner, Obj attached, Obj victim

if (!attached.AsHero().IsValid)
	if (owner.AsHero().IsValid) {
		owner.Heal(5);
		if (rand(10) == 0) {
			Unit u;
			u = Place("GGhost", victim.pos, attached.player);
			u.SetStamina(5);
			u.SetLevel(attached.AsUnit().level);
			u.SetCommand("spawn");
			SwapSelectedObj(victim, u);
		}
	}