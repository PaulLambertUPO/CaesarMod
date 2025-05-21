//void, Obj This

Obj this;
ObjList list;
Unit u;
point pos;
int player, range, dead_hero_level, grave_lifetime, units_blessed, counter, i, k;
bool items_given;

this = This;

pos = .pos;
range = .range;
player = .player;

dead_hero_level = .maxstamina;
grave_lifetime = 61 + 20 * dead_hero_level;
.SetMaxHealth(grave_lifetime + 1);
.SetHealth(grave_lifetime + 1);

.StartAnim(1, pos);
Sleep(rand(1000) + .TimeToAnimFinish());//this is for when there are huge amounts of graves

while (1) {
	Sleep(1000);

	grave_lifetime -= 1;
	.SetHealth(grave_lifetime + 1);
	if (grave_lifetime == 120)
		.SetState(2);
	else if (grave_lifetime == 60)
		.SetState(3);
	else if (grave_lifetime == 30)
		.SetState(4);
	else if (grave_lifetime == 15)
		.SetState(5);
	else if (grave_lifetime == 0)
		break;

	counter += 1;
	if (counter % 4 == 0) {
		list = Intersect(ObjsInCircle(pos, range, "Hero"), ClassPlayerObjs("Hero", player)).GetObjList();
		list.ClearDead();
		for (i = 0; i < list.count; i += 1) {
			u = list[i].AsUnit();
			if (u.IsValid)
				if (u.level < dead_hero_level * 4 / 5) {
					u.SetLevel(u.level + 1);
					CreateFeedback("Experience", u);
				}
		}
	}
	if (counter % 5 == 0)
		.SetStamina(.stamina + 1);

	if (.stamina == 0)
		continue;

	list = Intersect(ObjsInCircle(pos, range, "Military"), ClassPlayerObjs("Military", player)).GetObjList();
	list.ClearDead();
	k = list.count;
	i = rand(k);
	units_blessed = 0;
	while (k > 0) {
		u = list[i].AsUnit();
		if (u.IsValid)
			if (!u.AsHero().IsValid) {
				items_given = false;
				if (!u.HasItem("Damage charm")) {
					u.AddItem("Damage charm");
					items_given = true;
				}
				if (!u.HasItem("Armor charm")) {
					u.AddItem("Armor charm");
					items_given = true;
				}
				if (!u.HasItem("Health charm")) {
					u.AddItem("Health charm");
					items_given = true;
				}
				if (!u.HasItem("Knowledge charm")) {
					u.AddItem("Knowledge charm");
					items_given = true;
				}
				if (items_given) {
					.SetStamina(.stamina - 1);
					if (.stamina <= 0)
						break;
					units_blessed += 1;
					if (units_blessed >= 5)
						break;
				}
			}
		i += 1;
		if (i >= list.count)
			i = 0;
		k -= 1;
	}
}

.StartAnim(9, pos);
Sleep(.TimeToAnimFinish());
.Erase();
Sleep(10000);