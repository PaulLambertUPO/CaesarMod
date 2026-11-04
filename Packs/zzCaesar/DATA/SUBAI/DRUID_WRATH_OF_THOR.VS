//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		while (!.Goto(pt, .sight, 2000, false, 2500))
			;

		.PlayAnim(18, pt);
		CreateFeedback("Lightning", .pos);
		.PlayAnim(18, pt);
		CreateFeedback("Lightning2", .pos);
		.PlayAnim(18, pt);

		Place("WrathOfThor", pt, .player).SetStamina(10);

		.Damage(.health);
	}