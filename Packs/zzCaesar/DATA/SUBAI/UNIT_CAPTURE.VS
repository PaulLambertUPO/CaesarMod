//void, Obj This, Obj target

if (target.IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive) {
			int plr;

			plr = .player;

			if (target.player != plr) {
				.SetParryMode(false);

				if (target.AsBuilding().IsValid) {
					if (.IsValidCaptureTarget(target)) {
						Settlement set;

						set = target.AsBuilding().settlement;

						if (!target.AsBuilding().IsCentralBuliding)
							target = set.GetCentralBuilding();

						while (!.Goto(target, 250, 1500, false, 0))
							;

						if (target.player != plr)
							if (.IsValidCaptureTarget(target)) {
								if (set.IsTTent) {
									if (target.IsEnemy(this)) {
										if (.HasSpecial(sneak))
											.SetLastAttackTime();
										if (!.IsVisible)
											.SetVisible(true);
										.AddCommand(true, "engage");
										Sleep(30);//prevent possible loops with other commands
										return;
									}
								}
								else if (set.IsOutpost)
									if (set.IsIndependent) {
										if (.HasSpecial(sneak))
											.SetLastAttackTime();
										if (!.IsVisible)
											.SetVisible(true);
										.AddCommand(true, "engage");
										Sleep(30);//prevent possible loops with other commands
										return;
									}

								{
									point pt_pos;

									pt_pos = target.pos;

									while (target.player != plr) {
										if (!.IsValidCaptureTarget(target))
											break;
										if (.Goto(target, 250, 2500, true, 2500)) {
											if (target.player == plr)
												break;
											if (!.IsValidCaptureTarget(target))
												break;
											if (!target.IsEnemy(this)) {//non-hostile players immediately give the target (if enough time has passed)
												if (GetTime() > EnvReadInt(set, "JustCapturedSecurityThreshold")) {
													set.SetPlayer(plr);
													EnvWriteInt(set, "JustCapturedSecurityThreshold", GetTime() + 3000);
												}
												break;
											}
											while (target.IsEnemy(this)) {
												if (set.loyalty <= 0) {
													set.SetPlayer(plr);
													set.SetLoyalty(11);
													EnvWriteInt(set, "JustCapturedSecurityThreshold", GetTime() + 3000);
													break;
												}
												UserNotification("building attacked", "", pt_pos, target.player);

												.SetLastAttackTime();
												if (!.IsVisible)
													.SetVisible(true);

												.Face(pt_pos);
												.Taunt(2000);

												if (target.player == plr)
													break;
												if (!.IsValidCaptureTarget(target))
													break;
												if (target.IsEnemy(this))
													set.DecreaseLoyalty(1);
												else {
													if (GetTime() > EnvReadInt(set, "JustCapturedSecurityThreshold")) {
														set.SetPlayer(plr);
														EnvWriteInt(set, "JustCapturedSecurityThreshold", GetTime() + 3000);
													}
													break;
												}
											}
										}
									}
								}
							}
					}
				}
				else if (target.AsWagon().IsValid) {
					Wagon w;

					w = target.AsWagon();

					while (w.IsAlive) {
						if (w.player == plr)
							break;
						if (w.InHolder)
							break;
						if (.Goto(w, 150, 2500, true, 2500)) {
							if (w.IsDead)
								break;
							if (w.player == plr)
								break;
							if (w.InHolder)
								break;
							if (!w.IsEnemy(this)) {//non-hostile players immediately give the target
								w.SetPlayer(plr);
								break;
							}
							if (w.loyalty <= 0) {
								w.SetPlayer(plr);
								break;
							}
							UserNotification("unit attacked", "", w.pos, w.player);

							.SetLastAttackTime();
							if (!.IsVisible)
								.SetVisible(true);

							.Face(w.pos);
							.Taunt(2000);

							if (w.IsAlive)
								if (w.player != plr)
									if (!w.InHolder)
										if (w.IsEnemy(this))
											w.DecreaseLoyalty(1);
										else {
											w.SetPlayer(plr);
											break;
										}
						}
					}
				}
				else if (target.IsHeirOf("WildHorse"))
					if (IsResearched(plr, "Tame horses")) {
						Unit u;

						u = target.AsUnit();

						while (u.IsAlive) {
							if (u.player == plr)
								break;
							if (u.InHolder)
								break;
							if (.Goto(u, 150, 2500, true, 2500)) {
								if (u.IsDead)
									break;
								if (u.player == plr)
									break;
								if (u.InHolder)
									break;
								if (!u.IsEnemy(this)) {//non-hostile players immediately give the target
									u.SetPlayer(plr);
									break;
								}
								UserNotification("unit attacked", "", u.pos, u.player);

								.SetLastAttackTime();
								if (!.IsVisible)
									.SetVisible(true);

								.Face(u.pos);
								.Taunt(2000);

								if (u.IsAlive)
									if (u.player != plr)
										if (!u.InHolder) {
											u.SetPlayer(plr);
											u.SetCommand("move", .pos);
											UserNotification("horse captured", "", u.pos, plr);
										}
							}
						}
					}
			}
		}
}

Sleep(30);//prevent possible loops with other commands