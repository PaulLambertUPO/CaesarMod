//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		.PlayAnim(19, .pos);

		u = Place("DeerSummoned", .posRH, .player).AsUnit();
		u.SetLevel(.inherentlevel);
		u.SetNoAIFlag(true);

		SwapSelectedObj(this, u);

		.SetSummoningDeath(true);
		.Damage(.health);
	}