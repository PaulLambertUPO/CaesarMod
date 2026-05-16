//void, Obj This

Building this;
Settlement set;
ObjList ol, ol_training, ol_training_new, ol_inside, ol_outside, ol_healers, ol_teachers, ol_to_heal_in, ol_to_heal_out, ol_to_teach, ol_to_train, ol_to_learn;
Unit u, u_to_learn_from;
point pt_exit;
int i, j, plr, teaching_level_1, teaching_level_2, n_training, max_level_learn, max_level_train, max_level_teach, n_to_heal, n_to_learn, n_to_teach;
bool b;

this = This.AsBuilding();
set = .settlement;
plr = .player;

Sleep(1000 + rand(1001));

teaching_level_1 = GetConst("TeachingLevel1");
teaching_level_2 = GetConst("TeachingLevel2");

pt_exit.SetLen(.radius + 100);
pt_exit = pt_exit + .pos;

while (true) {
	if (plr != .player) {
		plr = .player;
		ol_training.Clear();
	}

	if (EnvReadString(set, "autotrain") == "on") {
		ol_inside.Clear();

		if (ol_training.count + set.UnitsCount > 0) {
			ol = set.Units;
			for (i = ol.count - 1; i >= 0; i -= 1) {
				u = ol[i].AsUnit();
				if (u.IsAlive)
					if (u.player == plr)
						if (u.IsMilitary || u.IsReligious) {
							if (!u.GetFlags(UNITFLAG_NOAI))
								ol_inside.Add(u);
							if (u.GetCommanded())
								u.SetCommanded(false);
							if (u.AsHero().IsValid) {
								ol_outside = u.AsHero().army;
								for (j = ol_outside.count - 1; j >= 0; j -= 1) {
									u = ol_outside[j].AsUnit();
									if (u.IsAlive)
										if (u.IsMilitary || u.IsReligious)
											if (!u.GetFlags(UNITFLAG_NOAI))
												if (set == u.GetHolderSett()) {
													ol_inside.Add(u);
													if (u.GetCommanded())
														u.SetCommanded(false);
												}
								}
							}
						}
			}

			ol_training.RemoveList(ol_inside);
			ol_training.ClearDead();

			if (ol_training.count + ol_inside.count > 0) {
				ol_outside.Clear();
				for (i = ol_training.count - 1; i >= 0; i -= 1) {
					u = ol_training[i].AsUnit();
					if (u.IsAlive)
						if (!u.GetCommanded())
							if (u.hero.IsDead)
								ol_outside.Add(u);
							else if (!u.hero.GetCommanded())
								ol_outside.Add(u);
				}

				if (ol_inside.count + ol_outside.count > 0) {
					ol_healers.Clear();//units in these lists could exist also in one of the lists below
					ol_teachers.Clear();

					ol_to_heal_in.Clear();//units in these lists cannot exist in any of the lists above
					ol_to_heal_out.Clear();
					ol_to_teach.Clear();
					ol_to_train.Clear();
					ol_to_learn.Clear();

					u_to_learn_from.Clear();
					max_level_learn = 0;

					ol = ol_outside;
					ol.AddList(ol_inside);
					for (i = ol.count - 1; i >= 0; i -= 1) {//specify healers, teachers and unit to learn from
						u = ol[i].AsUnit();
						if (u.IsAlive) {
							if (u.IsReligious)
								if (u.HasSpecial(healing))
									ol_healers.Add(u);
								else if (u.HasSpecial(teaching))
									ol_teachers.Add(u);
							j = u.inherentlevel;
							if (j > max_level_learn) {
								u_to_learn_from = u;
								max_level_learn = j;
							}
							else if (j == max_level_learn)
								if (!u.AsHero().IsValid)
									if (u_to_learn_from.IsAlive)
										if (u_to_learn_from.AsHero().IsValid) {
											u_to_learn_from = u;
											max_level_learn = j;
										}
										else if (u_to_learn_from.health < u.health) {
											u_to_learn_from = u;
											max_level_learn = j;
										}
						}
					}

					max_level_train = EnvReadInt(plr, "maxtrainlevel");
					if (ol_teachers.count > 0) {
						max_level_teach = teaching_level_1;
						if (IsResearched(plr, "Ancestral Knowledge"))
							max_level_teach = teaching_level_2;
					}
					else
						max_level_teach = 0;

					n_to_teach = 0;
					n_to_heal = 0;
					n_to_learn = 0;
					for (i = ol_outside.count - 1; i >= 0; i -= 1) {//specify units for what they can do
						u = ol_outside[i].AsUnit();
						if (u.IsAlive)
							if (!u.GetCommanded()) {
								if (u.hero.IsDead)
									b = true;
								else if (!u.hero.GetCommanded())
									b = true;
								else
									b = false;
								if (b) {
									j = u.inherentlevel;
									if (u.IsMilitary) {
										if (j < max_level_train) {
											n_to_heal += 1;
											if (j < max_level_teach)
												n_to_teach += 1;
											if (u.health * 2 > u.maxhealth)
												ol_to_train.Add(u);
											else
												ol_to_heal_out.Add(u);
										}
										else if (j < max_level_teach) {
											n_to_teach += 1;
											if (u.health < u.maxhealth)
												n_to_heal += 1;
											ol_to_teach.Add(u);
										}
										else if (u.health < u.maxhealth) {
											n_to_heal += 1;
											ol_to_heal_out.Add(u);
										}
									}
									else {
										if (j < max_level_teach) {
											n_to_teach += 1;
											if (u.health < u.maxhealth)
												n_to_heal += 1;
											ol_to_teach.Add(u);
										}
										else if (u.health < u.maxhealth) {
											n_to_heal += 1;
											ol_to_heal_out.Add(u);
										}
										if (j < max_level_learn) {
											n_to_learn += 1;
											ol_to_learn.Add(u);
										}
									}
								}
							}
					}

					n_training = ol_to_heal_out.count + ol_to_teach.count + ol_to_train.count + ol_to_learn.count;

					for (i = ol_inside.count - 1; i >= 0; i -= 1) {
						u = ol_inside[i].AsUnit();
						if (u.IsAlive) {
							if (n_training < 30)
								b = true;
							else if (u.AsHero().IsValid)
								b = true;
							else
								b = false;
							if (b) {
								j = u.inherentlevel;
								if (u.IsMilitary) {
									if (j < max_level_train) {
										n_training += 1;
										n_to_heal += 1;
										if (j < max_level_teach)
											n_to_teach += 1;
										if (u.health < u.maxhealth)
											ol_to_heal_in.Add(u);
										else
											ol_to_train.Add(u);
									}
									else if (j < max_level_teach) {
										n_training += 1;
										n_to_teach += 1;
										if (u.health < u.maxhealth)
											n_to_heal += 1;
										ol_to_teach.Add(u);
									}
									else if (u.health < u.maxhealth) {
										n_training += 1;
										n_to_heal += 1;
										ol_to_heal_in.Add(u);
									}
								}
								else {
									if (j < max_level_teach) {
										b = false;
										n_training += 1;
										n_to_teach += 1;
										if (u.health < u.maxhealth)
											n_to_heal += 1;
										ol_to_teach.Add(u);
									}
									else if (u.health < u.maxhealth) {
										b = false;
										n_training += 1;
										n_to_heal += 1;
										ol_to_heal_in.Add(u);
									}
									if (j < max_level_learn) {
										if (b)
											n_training += 1;
										n_to_learn += 1;
										ol_to_learn.Add(u);
									}
								}
							}
						}
					}

					if (ol_to_train.count == 1) {//a single unit cannot train -> use another group
						u = ol_to_train[0].AsUnit();
						if (u.IsAlive)
							if (u.inherentlevel < max_level_teach)
								ol_to_teach.Add(u);
							else if (u.health < u.maxhealth)
								if (u.InHolder)
									ol_to_heal_in.Add(u);
								else
									ol_to_heal_out.Add(u);
							else
								n_to_heal -= 1;
						ol_to_train.Clear();
					}

					if (n_to_heal == 1)//a single healer cannot self-heal -> use another group
						if (ol_healers.count == 1)
							if (ol_to_train.count <= 0) {
								u = ol_healers[0].AsUnit();
								if (u.IsAlive)
									if (u.health < u.maxhealth) {
										n_to_heal = 0;
										if (u.inherentlevel < max_level_teach)
											ol_to_teach.Add(u);
										ol_to_heal_in.Clear();
										ol_to_heal_out.Clear();
									}
							}
					if (n_to_heal <= 0) {//roaming healers will go back to the townhall
						ol_healers.RemoveList(ol_to_teach);
						ol_healers.Clear();
					}
					else {
						ol_to_heal_in.RemoveList(ol_healers);
						ol_to_heal_out.RemoveList(ol_healers);
					}

					if (ol_teachers.count > 0) {//discard teachers if they have nothing to do
						if (n_to_teach <= 0)
							b = true;
						else if (n_to_teach <= 1)
							b = ol_teachers.count == 1;
						else
							b = false;
						if (b) {
							if (n_to_teach == 1)	{
								u = ol_teachers[0].AsUnit();
								if (u.IsAlive)
									if (u.inherentlevel >= max_level_teach)
										b = false;//the single unit to teach is not the teacher
							}
							if (b) {
								n_to_teach = 0;
								ol_teachers.Clear();
								ol_to_teach.Clear();
							}
						}
					}
					if (ol_teachers.count > 4 * n_to_teach) {
						ol = ol_teachers;
						ol.RemoveList(ol_outside);//teachers inside
						ol_teachers.RemoveList(ol);//teachers outside
						for (i = 4 * n_to_teach - ol_teachers.count - 1; i >= 0; i -= 1)
							ol_teachers.Add(ol[i]);
					}
					if (ol_healers.count > n_training) {
						ol = ol_healers;
						ol.RemoveList(ol_outside);//healers inside
						ol_healers.RemoveList(ol);//healers outside
						for (i = n_training - ol_healers.count - 1; i >= 0; i -= 1)
							ol_healers.Add(ol[i]);
					}

					ol_training_new.Clear();
					ol_training_new.AddList(ol_healers);
					ol_training_new.AddList(ol_teachers);
					ol_training_new.AddList(ol_to_train);
					ol_training_new.AddList(ol_to_learn);
					if (n_to_learn > 0)
						ol_training_new.Add(u_to_learn_from);

					if (n_to_teach <= ol_teachers.count)
						ol_training_new.AddList(ol_to_teach);
					else {
						j = ol_to_teach.count;
						ol_to_teach.RemoveList(ol_teachers);
						ol_to_teach.RemoveList(ol_healers);
						j = MIN(ol_to_teach.count, 1 + ol_teachers.count - (j - ol_to_teach.count));
						if (j > 0) {
							for (i = ol_to_teach.count - 1; i >= 0; i -= 1) {//heroes should always be trained
								u = ol_to_teach[i].AsUnit();
								if (u.IsAlive)
									if (u.AsHero().IsValid)
										ol_training_new.Add(u);
							}
							ol = ol_to_teach;
							ol.RemoveList(ol_inside);
							i = ol.count;
							if (i >= j)
								for (i = 0; i < j; i += 1)
									ol_training_new.Add(ol[i]);
							else {
								ol_training_new.AddList(ol);
								ol_to_teach.RemoveList(ol);
								j -= i;
								if (j > 1)
									j -= 1;
								for (i = 0; i < j; i += 1)
									ol_training_new.Add(ol_to_teach[i]);
							}
						}
					}

					if (set.food > 0)
						n_to_heal = 2 * ol_healers.count;
					else
						n_to_heal = 1000 * ol_healers.count;

					j = 0;
					for (i = ol_training_new.count - 1; i >= 0; i -= 1) {
						u = ol_training_new[i].AsUnit();
						if (u.IsAlive)
							if (u.health < u.maxhealth)
								j += 1;
					}
					if (j >= n_to_heal) {
						ol_to_heal_in.AddList(ol_to_heal_out);
						ol_to_heal_out.Clear();
					}
					else {
						ol.Clear();
						j = n_to_heal - j;
						if (ol_to_heal_out.count > j) {
							for (i = ol_to_heal_out.count - j - 1; i >= 0; i -= 1)
								ol.Add(ol_to_heal_out[i]);
							ol_to_heal_in.AddList(ol);
							ol_to_heal_out.RemoveList(ol);
						}
						else {
							j -= ol_to_heal_out.count;
							if (j > ol_to_heal_in.count)
								ol.AddList(ol_to_heal_in);
							else
								for (i = 0; i < j; i += 1)
									ol.Add(ol_to_heal_in[i]);
							ol_to_heal_in.RemoveList(ol);
							ol_to_heal_out.AddList(ol);
						}
						ol_training_new.AddList(ol_to_heal_out);
					}

					if (ol_teachers.count > 0) {//teachers will go back to the townhall if there is nothing to do
						for (i = ol_training_new.count - 1; i >= 0; i -= 1) {
							u = ol_training_new[i].AsUnit();
							if (u.IsAlive)
								if (u.inherentlevel < max_level_teach)
									break;
						}
						if (i < 0) {
							ol_teachers.RemoveList(ol_to_heal_in);
							ol_teachers.RemoveList(ol_to_heal_out);
							ol_training_new.RemoveList(ol_teachers);
							ol_teachers.Clear();
						}
					}

					ol_outside.RemoveList(ol_training_new);//ol_outside and ol_training_new contain all old and new units outside respectively
					ol_outside.ClearDead();
					ol_outside.SetCommand("enter_alone", this);//non-training units

					ol = ol_inside;
					ol.RemoveList(ol_training_new);
					ol_inside.RemoveList(ol);
					ol_inside.SetCommand("advance_alone", pt_exit);

					ol = ol_to_train;
					ol.RemoveList(ol_inside);
					ol.SetCommand("train");
					ol_to_train.RemoveList(ol);
					ol_to_train.AddCommand(false, "train");

					ol = ol_to_learn;
					ol.RemoveList(ol_inside);
					ol.SetCommand("learn", u_to_learn_from);
					ol_to_learn.RemoveList(ol);
					ol_to_learn.AddCommand(false, "learn", u_to_learn_from);

					ol_training = ol_training_new;
					ol_training.AddList(ol_outside);//this is needed because the hero can mess up in the process
				}
			}
		}
	}
	else if (ol_training.count > 0) {
		for (i = ol_training.count - 1; i >= 0; i -= 1) {
			u = ol_training[i].AsUnit();
			if (u.IsAlive)
				if (!u.GetCommanded())
					if (u.hero.IsDead)
						u.SetCommand("enter", this);
					else if (!u.hero.GetCommanded())
						u.SetCommand("enter", this);
		}
		ol_training.Clear();
	}

	Sleep(7500);
}