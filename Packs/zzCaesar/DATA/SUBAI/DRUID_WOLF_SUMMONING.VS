//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		.PlayAnim(19, .pos);

		u = Place("WolfSummoned", .posRH, .player).AsUnit();
		u.SetLevel(.level);
		u.SetNoAIFlag(true);
		u.SetCommand("engage");

		SwapSelectedObj(this, u);

		.SetSummoningDeath(true);
		.Damage(.health);
	}