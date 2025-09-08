//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid) {
	Unit u;

	.PlayAnim(19, .pos);

	u = Place("EagleSummoned", .posRH, .player);
	u.SetStamina(10);
	u.SetLevel(.inherentlevel);
	u.SetNoAIFlag(true);

	SwapSelectedObj(this, u);

	.SetSummoningDeath(true);
	.Damage(.health);
}