//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive) {
		while (!.Goto(pt, .sight, 2000, false, 2500))
			;

		.PlayAnim(18, .pos);

		Place("Mist", pt, .player).SetStamina(10);

		.PlaySound("Data/Sound Entities/Mist.xml");

		.Damage(.health);
	}