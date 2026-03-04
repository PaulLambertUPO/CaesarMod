//void, Obj This

Sleep(1000 + rand(501));

if (GetConst("NoSentries") == 0) {
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		Settlement set;

		set = .settlement;

		while (set.IsIndependent)
			Sleep(5000);

		{
			Obj target;
			Unit s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12;//all sentry-related variables follow the clock hours
			point pt_pos, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12;
			int i, plr, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, sentry_level = 1;
			str sentry_class;
			bool enemies_in_sight = false;

			pt_pos = .pos;

			p1 = pt_pos + Point(65, -276);
			p2 = pt_pos + Point(260, -90);
			p3 = pt_pos + Point(300, -70);
			p4 = pt_pos + Point(260, -20);
			p5 = pt_pos + Point(45, 185);
			p6 = pt_pos + Point(0, 215);
			p7 = pt_pos + Point(-50, 185);
			p8 = pt_pos + Point(-247, -10);
			p9 = pt_pos + Point(-281, -40);
			p10 = pt_pos + Point(-247, -80);
			p11 = pt_pos + Point(-32, -276);
			p12 = pt_pos + Point(19, -295);

			plr = .player;

			i = GetPlayerRace(plr);
			if (i == ImperialRome)//Greece
				sentry_class = "HGuardPostSentry";
			else
				sentry_class = GetRaceStrPref(i) + "GuardPostSentry";

			i = -1;//reset the level timer (-1 because there is no sleep in the first iteration)

			while (1) {
				if (.IsBroken || plr != .player) {//kill all sentries and reset level timer and sentry class
					if (s1.IsAlive)
						s1.Damage(s1.health);
					if (s2.IsAlive)
						s2.Damage(s2.health);
					if (s3.IsAlive)
						s3.Damage(s3.health);
					if (s4.IsAlive)
						s4.Damage(s4.health);
					if (s5.IsAlive)
						s5.Damage(s5.health);
					if (s6.IsAlive)
						s6.Damage(s6.health);
					if (s7.IsAlive)
						s7.Damage(s7.health);
					if (s8.IsAlive)
						s8.Damage(s8.health);
					if (s9.IsAlive)
						s9.Damage(s9.health);
					if (s10.IsAlive)
						s10.Damage(s10.health);
					if (s11.IsAlive)
						s11.Damage(s11.health);
					if (s12.IsAlive)
						s12.Damage(s12.health);

					if (set.IsIndependent)
						return;
					else {
						plr = .player;
						i = GetPlayerRace(plr);
						if (i == ImperialRome)//Greece
							sentry_class = "HGuardPostSentry";
						else
							sentry_class = GetRaceStrPref(i) + "GuardPostSentry";
						sentry_level = 1;
						i = 0;
						t1 = 12;
						t2 = 12;
						t3 = 12;
						t4 = 12;
						t5 = 12;
						t6 = 12;
						t7 = 12;
						t8 = 12;
						t9 = 12;
						t10 = 12;
						t11 = 12;
						t12 = 12;
					}
				}
				else {//manage level timer and all sentries (those in the corners just look around, the others move back and forth)
					if (sentry_level < 36) {
						i += 1;
						if (i >= 60) {
							sentry_level += 1;
							i = 0;
						}
					}

					if (s1.IsValid) {
						if (s1.IsAlive) {
							if (s1.inherentlevel < sentry_level)
								s1.SetLevel(sentry_level);
							if (s1.command != "attack") {
								target = s1.BestTargetForPos;
								if (s1.IsValidTarget(target))
									s1.SetCommand("attack", target);
								if (s1.command == "idle") {
									s1.SetCommand("goto", p1 + Point(75, 75));
									s1.AddCommand(false, "face", p1 + Point(76, 74));
									s1.AddCommand(false, "goto", p1);
									s1.AddCommand(false, "face", p1 + Point(1, -1));
								}
							}
						}
					}
					else {
						t1 -= 1;
						if (t1 <= 0) {
							s1 = Place(sentry_class, p1, plr).AsUnit();
							s1.SetLevel(sentry_level);
							s1.Face(p1 + Point(1, -1));
							t1 = 12;
						}
					}

					if (s2.IsValid) {
						if (s2.IsAlive) {
							if (s2.inherentlevel < sentry_level)
								s2.SetLevel(sentry_level);
							if (s2.command != "attack") {
								target = s2.BestTargetForPos;
								if (s2.IsValidTarget(target))
									s2.SetCommand("attack", target);
								if (s2.command == "idle") {
									s2.SetCommand("goto", p2 + Point(-25, -25));
									s2.AddCommand(false, "face", p2 + Point(-24, -26));
									s2.AddCommand(false, "goto", p2);
									s2.AddCommand(false, "face", p2 + Point(1, -1));
								}
							}
						}
					}
					else {
						t2 -= 1;
						if (t2 <= 0) {
							s2 = Place(sentry_class, p2, plr).AsUnit();
							s2.SetLevel(sentry_level);
							s2.Face(p2 + Point(1, -1));
							t2 = 12;
						}
					}

					if (s3.IsValid) {
						if (s3.IsAlive) {
							if (s3.inherentlevel < sentry_level)
								s3.SetLevel(sentry_level);
							if (s3.command != "attack") {
								target = s3.BestTargetForPos;
								if (s3.IsValidTarget(target))
									s3.SetCommand("attack", target);
								if (s3.command == "idle") {
									s3.SetCommand("face", p3 + Point(1, -1));
									s3.AddCommand(false, "face", p3 + Point(1, 0));
									s3.AddCommand(false, "face", p3 + Point(1, 1));
									s3.AddCommand(false, "face", p3 + Point(1, 0));
								}
							}
						}
					}
					else {
						t3 -= 1;
						if (t3 <= 0) {
							s3 = Place(sentry_class, p3, plr).AsUnit();
							s3.SetLevel(sentry_level);
							s3.Face(p3 + Point(1, 0));
							t3 = 12;
						}
					}

					if (s4.IsValid) {
						if (s4.IsAlive) {
							if (s4.inherentlevel < sentry_level)
								s4.SetLevel(sentry_level);
							if (s4.command != "attack") {
								target = s4.BestTargetForPos;
								if (s4.IsValidTarget(target))
									s4.SetCommand("attack", target);
								if (s4.command == "idle") {
									s4.SetCommand("face", p4 + Point(0, 1));
									s4.AddCommand(false, "face", p4 + Point(1, 1));
									s4.AddCommand(false, "face", p4 + Point(1, 0));
									s4.AddCommand(false, "face", p4 + Point(1, 1));
								}
							}
						}
					}
					else {
						t4 -= 1;
						if (t4 <= 0) {
							s4 = Place(sentry_class, p4, plr).AsUnit();
							s4.SetLevel(sentry_level);
							s4.Face(p4 + Point(1, 1));
							t4 = 12;
						}
					}

					if (s5.IsValid) {
						if (s5.IsAlive) {
							if (s5.inherentlevel < sentry_level)
								s5.SetLevel(sentry_level);
							if (s5.command != "attack") {
								target = s5.BestTargetForPos;
								if (s5.IsValidTarget(target))
									s5.SetCommand("attack", target);
								if (s5.command == "idle") {
									s5.SetCommand("goto", p5 + Point(80, -80));
									s5.AddCommand(false, "face", p5 + Point(81, -79));
									s5.AddCommand(false, "goto", p5);
									s5.AddCommand(false, "face", p5 + Point(1, 1));
								}
							}
						}
					}
					else {
						t5 -= 1;
						if (t5 <= 0) {
							s5 = Place(sentry_class, p5, plr).AsUnit();
							s5.SetLevel(sentry_level);
							s5.Face(p5 + Point(1, 1));
							t5 = 12;
						}
					}

					if (s6.IsValid) {
						if (s6.IsAlive) {
							if (s6.inherentlevel < sentry_level)
								s6.SetLevel(sentry_level);
							if (s6.command != "attack") {
								target = s6.BestTargetForPos;
								if (s6.IsValidTarget(target))
									s6.SetCommand("attack", target);
								if (s6.command == "idle") {
									s6.SetCommand("face", p6 + Point(-1, 1));
									s6.AddCommand(false, "face", p6 + Point(0, 1));
									s6.AddCommand(false, "face", p6 + Point(1, 1));
									s6.AddCommand(false, "face", p6 + Point(0, 1));
								}
							}
						}
					}
					else {
						t6 -= 1;
						if (t6 <= 0) {
							s6 = Place(sentry_class, p6, plr).AsUnit();
							s6.SetLevel(sentry_level);
							s6.Face(p6 + Point(0, 1));
							t6 = 12;
						}
					}

					if (s7.IsValid) {
						if (s7.IsAlive) {
							if (s7.inherentlevel < sentry_level)
								s7.SetLevel(sentry_level);
							if (s7.command != "attack") {
								target = s7.BestTargetForPos;
								if (s7.IsValidTarget(target))
									s7.SetCommand("attack", target);
								if (s7.command == "idle") {
									s7.SetCommand("goto", p7 + Point(-25, -25));
									s7.AddCommand(false, "face", p7 + Point(-26, -24));
									s7.AddCommand(false, "goto", p7);
									s7.AddCommand(false, "face", p7 + Point(-1, 1));
								}
							}
						}
					}
					else {
						t7 -= 1;
						if (t7 <= 0) {
							s7 = Place(sentry_class, p7, plr).AsUnit();
							s7.SetLevel(sentry_level);
							s7.Face(p7 + Point(-1, 1));
							t7 = 12;
						}
					}

					if (s8.IsValid) {
						if (s8.IsAlive) {
							if (s8.inherentlevel < sentry_level)
								s8.SetLevel(sentry_level);
							if (s8.command != "attack") {
								target = s8.BestTargetForPos;
								if (s8.IsValidTarget(target))
									s8.SetCommand("attack", target);
								if (s8.command == "idle") {
									s8.SetCommand("goto", p8 + Point(60, 60));
									s8.AddCommand(false, "face", p8 + Point(59, 61));
									s8.AddCommand(false, "goto", p8);
									s8.AddCommand(false, "face", p8 + Point(-1, 1));
								}
							}
						}
					}
					else {
						t8 -= 1;
						if (t8 <= 0) {
							s8 = Place(sentry_class, p8, plr).AsUnit();
							s8.SetLevel(sentry_level);
							s8.Face(p8 + Point(-1, 1));
							t8 = 12;
						}
					}

					if (s9.IsValid) {
						if (s9.IsAlive) {
							if (s9.inherentlevel < sentry_level)
								s9.SetLevel(sentry_level);
							if (s9.command != "attack") {
								target = s9.BestTargetForPos;
								if (s9.IsValidTarget(target))
									s9.SetCommand("attack", target);
								if (s9.command == "idle") {
									s9.SetCommand("face", p9 + Point(-1, 1));
									s9.AddCommand(false, "face", p9 + Point(-1, 0));
									s9.AddCommand(false, "face", p9 + Point(-1, -1));
									s9.AddCommand(false, "face", p9 + Point(-1, 0));
								}
							}
						}
					}
					else {
						t9 -= 1;
						if (t9 <= 0) {
							s9 = Place(sentry_class, p9, plr).AsUnit();
							s9.SetLevel(sentry_level);
							s9.Face(p9 + Point(-1, 0));
							t9 = 12;
						}
					}

					if (s10.IsValid) {
						if (s10.IsAlive) {
							if (s10.inherentlevel < sentry_level)
								s10.SetLevel(sentry_level);
							if (s10.command != "attack") {
								target = s10.BestTargetForPos;
								if (s10.IsValidTarget(target))
									s10.SetCommand("attack", target);
								if (s10.command == "idle") {
									s10.SetCommand("goto", p10 + Point(80, -80));
									s10.AddCommand(false, "face", p10 + Point(79, -81));
									s10.AddCommand(false, "goto", p10);
									s10.AddCommand(false, "face", p10 + Point(-1, -1));
								}
							}
						}
					}
					else {
						t10 -= 1;
						if (t10 <= 0) {
							s10 = Place(sentry_class, p10, plr).AsUnit();
							s10.SetLevel(sentry_level);
							s10.Face(p10 + Point(-1, -1));
							t10 = 12;
						}
					}

					if (s11.IsValid) {
						if (s11.IsAlive) {
							if (s11.inherentlevel < sentry_level)
								s11.SetLevel(sentry_level);
							if (s11.command != "attack") {
								target = s11.BestTargetForPos;
								if (s11.IsValidTarget(target))
									s11.SetCommand("attack", target);
								if (s11.command == "idle") {
									s11.SetCommand("face", p11 + Point(0, -1));
									s11.AddCommand(false, "face", p11 + Point(-1, -1));
									s11.AddCommand(false, "face", p11 + Point(-1, 0));
									s11.AddCommand(false, "face", p11 + Point(-1, -1));
								}
							}
						}
					}
					else {
						t11 -= 1;
						if (t11 <= 0) {
							s11 = Place(sentry_class, p11, plr).AsUnit();
							s11.SetLevel(sentry_level);
							s11.Face(p11 + Point(-1, -1));
							t11 = 12;
						}
					}

					if (s12.IsValid) {
						if (s12.IsAlive) {
							if (s12.inherentlevel < sentry_level)
								s12.SetLevel(sentry_level);
							if (s12.command != "attack") {
								target = s12.BestTargetForPos;
								if (s12.IsValidTarget(target))
									s12.SetCommand("attack", target);
								if (s12.command == "idle") {
									s12.SetCommand("face", p12 + Point(-1, -1));
									s12.AddCommand(false, "face", p12 + Point(0, -1));
									s12.AddCommand(false, "face", p12 + Point(1, -1));
									s12.AddCommand(false, "face", p12 + Point(0, -1));
								}
							}
						}
					}
					else {
						t12 -= 1;
						if (t12 <= 0) {
							s12 = Place(sentry_class, p12, plr).AsUnit();
							s12.SetLevel(sentry_level);
							s12.Face(p12 + Point(0, -1));
							t12 = 12;
						}
					}
				}

				if (Intersect(VisibleObjsInSight(this, "Military"), EnemyObjs(plr, "Military")).IsEmpty)
					enemies_in_sight = false;
				else if (!enemies_in_sight) {
					UserNotification("guard post revealing enemies", "", pt_pos, plr);
					enemies_in_sight = true;
				}

				Sleep(1000);
			}
		}
	}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);