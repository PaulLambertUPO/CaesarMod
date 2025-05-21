//void, Obj This

Sleep(1000 + rand(500));

if (GetConst("NoSentries") != 0)
	while (1)
		Sleep(3600000);
else {
	Building this;
	Settlement set;
	ObjList sentries;
	Unit s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, target;
	IntArray posX, posY, sentry_timers;
	StrArray sentry_actions;
	point p;
	str sentry_class;
	int Greece, i, owner, level_timer, level = 1;
	bool enemies_in_sight = false;

	this = This.AsBuilding();

	set = .settlement;

	while (!set.IsValid)
		Sleep(100000);

	while (set.IsIndependent)
		Sleep(5000);

	p = .pos;
	owner = .player;
	Greece = ImperialRome;

	posX[0] = -247;
	posY[0] = -80;
	posX[1] = -281;
	posY[1] = -40;
	posX[2] = -247;
	posY[2] = -10;
	posX[3] = 19;
	posY[3] = -295;
	posX[4] = -32;
	posY[4] = -276;
	posX[5] = 65;
	posY[5] = -276;
	posX[6] = 0;
	posY[6] = 215;
	posX[7] = -50;
	posY[7] = 185;
	posX[8] = 45;
	posY[8] = 185;
	posX[9] = 260;
	posY[9] = -20;
	posX[10] = 260;
	posY[10] = -90;
	posX[11] = 300;
	posY[11] = -70;

	i = GetPlayerRace(owner);
	if (i == Greece)
		sentry_class = "HGuardPostSentry";
	else
		sentry_class = GetRaceStrPref(i) + "GuardPostSentry";

	while (1) {
		sentries.ClearDead();
		if (.IsBroken() || .player != owner) {
			for (i = 0; i < sentries.count; i += 1)
				sentries[i].Damage(sentries[i].maxhealth);
			level = 1;
			owner = .player;
			for (i = 0; i < 12; i += 1) {
				sentry_actions[i] = "";
				sentry_timers[i] = rand(4) + 1;
			}
			if (set.IsIndependent)//this is probably impossible to happen, in that case just restart the script and wait for the initial independent check loop to end
				return;
			else {
				i = GetPlayerRace(owner);
				if (i == Greece)
					sentry_class = "HGuardPostSentry";
				else
					sentry_class = GetRaceStrPref(i) + "GuardPostSentry";
			}
		}
		if (!.IsBroken()) {
			if (.health < .maxhealth)
				.Heal(6);
			if (level < 36)
				if (level_timer < 20)
					level_timer += 1;
				else {
					level_timer = 1;//if you set 0 and keep the condition like this and the sleep at the end, level increment happens every 63 seconds instead of 60
					level += 1;
				}
			if (!s0.IsValid)
				if (sentry_timers[0] > 0)
					sentry_timers[0] -= 1;
				else {
					sentry_actions[0] = "";
					sentry_timers[0] = rand(4) + 1;
					s0 = Place(sentry_class, p + Point(posX[0], posY[0]), owner);
					sentries.Add(s0);
				}
			if (!s1.IsValid)
				if (sentry_timers[1] > 0)
					sentry_timers[1] -= 1;
				else {
					sentry_actions[1] = "";
					sentry_timers[1] = rand(4) + 1;
					s1 = Place(sentry_class, p + Point(posX[1], posY[1]), owner);
					sentries.Add(s1);
				}
			if (!s2.IsValid)
				if (sentry_timers[2] > 0)
					sentry_timers[2] -= 1;
				else {
					sentry_actions[2] = "";
					sentry_timers[2] = rand(4) + 1;
					s2 = Place(sentry_class, p + Point(posX[2], posY[2]), owner);
					sentries.Add(s2);
				}
			if (!s3.IsValid)
				if (sentry_timers[3] > 0)
					sentry_timers[3] -= 1;
				else {
					sentry_actions[3] = "";
					sentry_timers[3] = rand(4) + 1;
					s3 = Place(sentry_class, p + Point(posX[3], posY[3]), owner);
					sentries.Add(s3);
				}
			if (!s4.IsValid)
				if (sentry_timers[4] > 0)
					sentry_timers[4] -= 1;
				else {
					sentry_actions[4] = "";
					sentry_timers[4] = rand(4) + 1;
					s4 = Place(sentry_class, p + Point(posX[4], posY[4]), owner);
					sentries.Add(s4);
				}
			if (!s5.IsValid)
				if (sentry_timers[5] > 0)
					sentry_timers[5] -= 1;
				else {
					sentry_actions[5] = "";
					sentry_timers[5] = rand(4) + 1;
					s5 = Place(sentry_class, p + Point(posX[5], posY[5]), owner);
					sentries.Add(s5);
				}
			if (!s6.IsValid)
				if (sentry_timers[6] > 0)
					sentry_timers[6] -= 1;
				else {
					sentry_actions[6] = "";
					sentry_timers[6] = rand(4) + 1;
					s6 = Place(sentry_class, p + Point(posX[6], posY[6]), owner);
					sentries.Add(s6);
				}
			if (!s7.IsValid)
				if (sentry_timers[7] > 0)
					sentry_timers[7] -= 1;
				else {
					sentry_actions[7] = "";
					sentry_timers[7] = rand(4) + 1;
					s7 = Place(sentry_class, p + Point(posX[7], posY[7]), owner);
					sentries.Add(s7);
				}
			if (!s8.IsValid)
				if (sentry_timers[8] > 0)
					sentry_timers[8] -= 1;
				else {
					sentry_actions[8] = "";
					sentry_timers[8] = rand(4) + 1;
					s8 = Place(sentry_class, p + Point(posX[8], posY[8]), owner);
					sentries.Add(s8);
				}
			if (!s9.IsValid)
				if (sentry_timers[9] > 0)
					sentry_timers[9] -= 1;
				else {
					sentry_actions[9] = "";
					sentry_timers[9] = rand(4) + 1;
					s9 = Place(sentry_class, p + Point(posX[9], posY[9]), owner);
					sentries.Add(s9);
				}
			if (!s10.IsValid)
				if (sentry_timers[10] > 0)
					sentry_timers[10] -= 1;
				else {
					sentry_actions[10] = "";
					sentry_timers[10] = rand(4) + 1;
					s10 = Place(sentry_class, p + Point(posX[10], posY[10]), owner);
					sentries.Add(s10);
				}
			if (!s11.IsValid)
				if (sentry_timers[11] > 0)
					sentry_timers[11] -= 1;
				else {
					sentry_actions[11] = "";
					sentry_timers[11] = rand(4) + 1;
					s11 = Place(sentry_class, p + Point(posX[11], posY[11]), owner);
					sentries.Add(s11);
				}
			if (s0.IsValid) {
				target = s0.BestTargetInRange(s0.pos, s0.range);
				if (s0.IsValidTarget(target) && s0.command != "attack") {
					s0.SetCommand("attack", target);
					sentry_actions[0] == "Return";
				}
				else if (s0.IsAlive) {
					if (sentry_actions[0] == "") {
						s0.SetCommand("move", p + Point(posX[0] + 90, posY[0] - 90));
						sentry_actions[0] = "Facing1";
					}
					if (sentry_actions[0] == "Facing2")
						if (s0.pos == p + Point(posX[0], posY[0])) {
							s0.Face(s0.pos + Point(-90, -90));
							sentry_actions[0] = "";
						}
					if (sentry_actions[0] == "Return") {
						s0.SetCommand("move", p + Point(posX[0], posY[0]));
						sentry_actions[0] = "Facing2";
					}
					if (sentry_actions[0] == "Facing1")
						if (s0.pos == p + Point(posX[0] + 90, posY[0] - 90)) {
							s0.Face(s0.pos + Point(-90, -90));
							sentry_actions[0] = "Return";
						}
				}
			}
			if (s1.IsValid) {
				target = s1.BestTargetInRange(s1.pos, s1.range);
				if (s1.IsValidTarget(target) && s1.command != "attack") {
					s1.SetCommand("attack", target);
					sentry_actions[1] = "Return";
				}
				else if (s1.IsAlive) {
					if (sentry_actions[1] == "Facing3") {
						s1.Face(s1.pos + Point(-90, -45));
						sentry_actions[1] = "";
					}
					if (sentry_actions[1] == "Facing2") {
						s1.Face(s1.pos + Point(-90, 0));
						sentry_actions[1] = "Facing3";
					}
					if (sentry_actions[1] == "Return") {
						s1.Stop(1000);
						sentry_actions[1] = "Facing2";
					}
					if (sentry_actions[1] == "Facing1") {
						s1.Face(s1.pos + Point(-90, 45));
						sentry_actions[1] = "Facing2";
					}
					if (sentry_actions[1] == "")
						sentry_actions[1] = "Facing1";
				}
			}
			if (s2.IsValid) {
				target = s2.BestTargetInRange(s2.pos, s2.range);
				if (s2.IsValidTarget(target) && s2.command != "attack") {
					s2.SetCommand("attack", target);
					sentry_actions[2] == "Return";
				}
				else if (s2.IsAlive) {
					if (sentry_actions[2] == "") {
						s2.SetCommand("move", p + Point(posX[2] + 60, posY[2] + 60));
						sentry_actions[2] = "Facing1";
					}
					if (sentry_actions[2] == "Facing2")
						if (s2.pos == p + Point(posX[2], posY[2])) {
							s2.Face(s2.pos + Point(-90, 90));
							sentry_actions[2] = "";
						}
					if (sentry_actions[2] == "Return") {
						s2.SetCommand("move", p + Point(posX[2], posY[2]));
						sentry_actions[2] = "Facing2";
					}
					if (sentry_actions[2] == "Facing1")
						if (s2.pos == p + Point(posX[2] + 60, posY[2] + 60)) {
							s2.Face(s2.pos + Point(-90,90));
							sentry_actions[2] = "Return";
						}
				}
			}
			if (s3.IsValid) {
				target = s3.BestTargetInRange(s3.pos, s3.range);
				if (s3.IsValidTarget(target) && s3.command != "attack") {
					s3.SetCommand("attack", target);
					sentry_actions[3] = "Return";
				}
				else if (s3.IsAlive) {
					if (sentry_actions[3] == "Facing3") {
						s3.Face(s3.pos + Point(45, -90));
						sentry_actions[3] = "";
					}
					if (sentry_actions[3] == "Facing2") {
						s3.Face(s3.pos + Point(0, -90));
						sentry_actions[3] = "Facing3";
					}
					if (sentry_actions[3] == "Facing1") {
						s3.Face(s3.pos + Point(-45, -90));
						sentry_actions[3] = "Facing2";
					}
					if (sentry_actions[3] == "Return") {
						s3.Stop(1000);
						sentry_actions[3] = "Facing2";
					}
					if (sentry_actions[3] == "")
						sentry_actions[3] = "Facing1";
				}
			}
			if (s4.IsValid) {
				target = s4.BestTargetInRange(s4.pos, s4.range);
				if (s4.IsValidTarget(target) && s4.command != "attack") {
					s4.SetCommand("attack", target);
					sentry_actions[4] == "Return";
				}
				else if (s4.IsAlive) {
					if (sentry_actions[4] == "") {
						s4.SetCommand("move", p + Point(posX[4] - 10, posY[4] + 10));
						sentry_actions[4] = "Facing1";
					}
					if (sentry_actions[4] == "Facing2")
						if (s4.pos == p + Point(posX[4], posY[4])) {
							s4.Face(s4.pos + Point(-90, -90));
							sentry_actions[4] = "";
						}
					if (sentry_actions[4] == "Return") {
						s4.SetCommand("move", p + Point(posX[4], posY[4]));
						sentry_actions[4] = "Facing2";
					}
					if (sentry_actions[4] == "Facing1")
						if (s4.pos == p + Point(posX[4] - 10, posY[4] + 10)) {
							s4.Face(s4.pos + Point(-90, -90));
							sentry_actions[4] = "Return";
						}
				}
			}
			if (s5.IsValid) {
				target = s5.BestTargetInRange(s5.pos, s5.range);
				if (s5.IsValidTarget(target) && s5.command != "attack") {
					s5.SetCommand("attack", target);
					sentry_actions[5] == "Return";
				}
				else if (s5.IsAlive) {
					if (sentry_actions[5] == "") {
						s5.SetCommand("move", p + Point(posX[5] + 75, posY[5] + 75));
						sentry_actions[5] = "Facing1";
					}
					if (sentry_actions[5] == "Facing2")
						if (s5.pos == p + Point(posX[5], posY[5])) {
							s5.Face(s5.pos + Point(90, -90));
							sentry_actions[5] = "";
						}
					if (sentry_actions[5] == "Return") {
						s5.SetCommand("move", p + Point(posX[5], posY[5]));
						sentry_actions[5] = "Facing2";
					}
					if (sentry_actions[5] == "Facing1")
						if (s5.pos == p + Point(posX[5] + 75, posY[5] + 75)) {
							s5.Face(s5.pos + Point(90, -90));
							sentry_actions[5] = "Return";
						}
				}
			}
			if (s6.IsValid) {
				target = s6.BestTargetInRange(s6.pos, s6.range);
				if (s6.IsValidTarget(target) && s6.command != "attack") {
					s6.SetCommand("attack", target);
					sentry_actions[6] = "Return";
				}
				else if (s6.IsAlive) {
					if (sentry_actions[6] == "Facing3") {
						s6.Face(s6.pos + Point(45, 90));
						sentry_actions[6] = "";
					}
					if (sentry_actions[6] == "Facing2") {
						s6.Face(s6.pos + Point(0, 90));
						sentry_actions[6] = "Facing3";
					}
					if (sentry_actions[6] == "Facing1") {
						s6.Face(s6.pos + Point(-45, 90));
						sentry_actions[6] = "Facing2";
					}
					if (sentry_actions[6] == "Return") {
						s6.Stop(1000);
						sentry_actions[6] = "Facing2";
					}
					if (sentry_actions[6] == "")
						sentry_actions[6] = "Facing1";
				}
			}
			if (s7.IsValid) {
				target = s7.BestTargetInRange(s7.pos, s7.range);
				if (s7.IsValidTarget(target) && s7.command != "attack") {
					s7.SetCommand("attack", target);
					sentry_actions[7] == "Return";
				}
				else if (s7.IsAlive) {
					if (sentry_actions[7] == "") {
						s7.SetCommand("move", p + Point(posX[7] - 25, posY[7] - 25));
						sentry_actions[7] = "Facing1";
					}
					if (sentry_actions[7] == "Facing2")
						if (s7.pos == p + Point(posX[7], posY[7])) {
							s7.Face(s7.pos + Point(-90, 90));
							sentry_actions[7] = "";
						}
					if (sentry_actions[7] == "Return") {
						s7.SetCommand("move", p + Point(posX[7], posY[7]));
						sentry_actions[7] = "Facing2";
					}
					if (sentry_actions[7] == "Facing1")
						if (s7.pos == p + Point(posX[7] - 25, posY[7] - 25)) {
							s7.Face(s7.pos + Point(-90, 90));
							sentry_actions[7] = "Return";
						}
				}
			}
			if (s8.IsValid) {
				target = s8.BestTargetInRange(s8.pos, s8.range);
				if (s8.IsValidTarget(target) && s8.command != "attack") {
					s8.SetCommand("attack", target);
					sentry_actions[8] == "Return";
				}
				else if (s8.IsAlive) {
					if (sentry_actions[8] == "") {
						s8.SetCommand("move", p + Point(posX[8] + 105, posY[8] - 105));
						sentry_actions[8] = "Facing1";
					}
					if (sentry_actions[8] == "Facing2")
						if (s8.pos == p + Point(posX[8], posY[8])) {
							s8.Face(s8.pos + Point(90, 90));
							sentry_actions[8] = "";
						}
					if (sentry_actions[8] == "Return") {
						s8.SetCommand("move", p + Point(posX[8], posY[8]));
						sentry_actions[8] = "Facing2";
					}
					if (sentry_actions[8] == "Facing1")
						if (s8.pos == p + Point(posX[8] + 105, posY[8] - 105)) {
							s8.Face(s8.pos + Point(90, 90));
							sentry_actions[8] = "Return";
						}
				}
			}
			if (s9.IsValid) {
				target = s9.BestTargetInRange(s9.pos, s9.range);
				if (s9.IsValidTarget(target) && s9.command != "attack") {
					s9.SetCommand("attack", target);
					sentry_actions[9] == "Return";
				}
				else if (s9.IsAlive) {
					if (sentry_actions[9] == "") {
						s9.SetCommand("move", p + Point(posX[9] - 10, posY[9] + 10));
						sentry_actions[9] = "Facing1";
					}
					if (sentry_actions[9] == "Facing2")
						if (s9.pos == p + Point(posX[9], posY[9])) {
							s9.Face(s9.pos + Point(90, 90));
							sentry_actions[9] = "";
						}
					if (sentry_actions[9] == "Return") {
						s9.SetCommand("move", p + Point(posX[9], posY[9]));
						sentry_actions[9] = "Facing2";
					}
					if (sentry_actions[9] == "Facing1")
						if (s9.pos == p + Point(posX[9] - 10, posY[9] + 10)) {
							s9.Face(s9.pos + Point(90, 90));
							sentry_actions[9] = "Return";
						}
				}
			}
			if (s10.IsValid) {
				target = s10.BestTargetInRange(s10.pos, s10.range);
				if (s10.IsValidTarget(target) && s10.command != "attack") {
					s10.SetCommand("attack", target);
					sentry_actions[10] == "Return";
				}
				else if (s10.IsAlive) {
					if (sentry_actions[10] == "") {
						s10.SetCommand("move", p + Point(posX[10] - 40, posY[10] - 40));
						sentry_actions[10] = "Facing1";
					}
					if (sentry_actions[10] == "Facing2")
						if (s10.pos == p + Point(posX[10], posY[10])) {
							s10.Face(s10.pos + Point(90, -90));
							sentry_actions[10] = "";
						}
					if (sentry_actions[10] == "Return") {
						s10.SetCommand("move", p + Point(posX[10], posY[10]));
						sentry_actions[10] = "Facing2";
					}
					if (sentry_actions[10]=="Facing1")
						if (s10.pos == p + Point(posX[10] - 40, posY[10] - 40)) {
							s10.Face(s10.pos + Point(90, -90));
							sentry_actions[10] = "Return";
						}
				}
			}
			if (s11.IsValid) {
				target = s11.BestTargetInRange(s11.pos, s11.range);
				if (s11.IsValidTarget(target) && s11.command != "attack") {
					s11.SetCommand("attack", target);
					sentry_actions[11] = "Return";
				}
				else if (s11.IsAlive) {
					if (sentry_actions[11] == "Facing3") {
						s11.Face(s11.pos + Point(45, 90));
						sentry_actions[11] = "";
					}
					if (sentry_actions[11] == "Facing2") {
						s11.Face(s11.pos + Point(90, 0));
						sentry_actions[11] = "Facing3";
					}
					if (sentry_actions[11] == "Facing1") {
						s11.Face(s11.pos + Point(45, -90));
						sentry_actions[11] = "Facing2";
					}
					if (sentry_actions[11] == "Return") {
						s11.Stop(1000);
						sentry_actions[11] = "Facing2";
					}
					if (sentry_actions[11] == "")
						sentry_actions[11] = "Facing1";
				}
			}
			for (i = 0; i < sentries.count; i += 1)
				sentries[i].AsUnit().SetLevel(level);
		}
		if (Intersect(VisibleObjsInSight(this, "Military"), EnemyObjs(owner, "Military")).IsEmpty())
			enemies_in_sight = false;
		else if (!enemies_in_sight) {
			UserNotification("guard post revealing enemies", "", .pos, owner);
			enemies_in_sight = true;
		}
		Sleep(3000);
	}
}