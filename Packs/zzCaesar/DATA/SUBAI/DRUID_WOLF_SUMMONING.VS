//void, Obj This

Druid this;

this = This.AsDruid();

if (.IsValid) {
	Unit u;

	.PlayAnim(19, .pos);

	u = Place("WolfSummoned", .posRH, .player);
	u.SetStamina(10);
	u.SetLevel(.inherentlevel);
	u.SetNoAIFlag(true);
	u.SetCommand("engage");

	SwapSelectedObj(this, u);

	.SetSummoningDeath(true);
	.Damage(.health);
}