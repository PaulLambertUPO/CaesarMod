//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid) {
	Unit u;

	.PlayAnim(19, .pos);

	u = Place("DeerSummoned", .posRH, .player);
	u.SetStamina(10);
	SwapSelectedObj(this, u);
	.SetSummoningDeath(true);
	.Damage(.health);
}