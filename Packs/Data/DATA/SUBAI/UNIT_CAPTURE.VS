//void, Obj me, Obj u

Unit this;

this = me.AsUnit();

if (.IsValid) {
	if (.player != u.player)
		if (.IsMilitary) {
			Building b;

			.SetParryMode(false);//leave parry mode at new command

			b = u.AsBuilding();

			if (b.IsValid) {
				if (!b.AsCatapult().IsValid) {
					Settlement set;
					bool is_tent_or_independent_outpost = false, is_enemy;

					set = b.settlement;

					if (!b.IsCentralBuliding)
						b = set.GetCentralBuilding();

					//tents and independent outposts
					while (.IsAlive) {
						if (.DistTo(b.pos) <= 500)
							break;
						if (.Goto(b, 0, 1237, false, 0))
							break;
					}
					if (.player == b.player)
						return;

					if (set.IsTTent)
						is_tent_or_independent_outpost = true;
					else if (set.IsOutpost())
						if (set.IsIndependent())
							is_tent_or_independent_outpost = true;

					while (.player != b.player) {
						if (!.IsValidCaptureTarget(b))
							return;
						if (.Goto(b, 250, 5000, true, 2500)) {
							if (.player == b.player)
								return;
							is_enemy = .IsEnemy(b);
							if (!is_enemy)
								if (!b.IsEnemy(this)) {//allied players management (note that it's different from using DiplAreAllied)
									set.SetPlayer(.player);
									return;
								}
							if (is_tent_or_independent_outpost) {
								if (!.IsVisible)
									.SetVisible(true);
								if (.HasSpecial(sneak))
									.SetLastAttackTime();
								.AddCommand(true, "engage");
								return;
							}
							while (is_enemy == .IsEnemy(b)) {
								if (set.loyalty <= 0) {
									set.SetPlayer(.player);
									set.SetLoyalty(11);
									return;
								}
								if (.IsEnemy(b))
									UserNotification("building attacked", "", b.pos, b.player);
								else if (b.IsEnemy(this))
									UserNotification("building attacked", "", b.pos, b.player);

								if (!.IsVisible)
									.SetVisible(true);
								if (.HasSpecial(sneak))
									.SetLastAttackTime();

								.Face(b.pos);
								.Taunt(2000);
								if (.IsEnemy(b))//loyalty sometimes decreases even after the capture
									set.DecreaseLoyalty(1);
							}
						}
					}
				}
			} 
			else if (u.IsHeirOf("Wagon")) {
				Wagon w;

				w = u.AsWagon();

				while (w.IsAlive) {
					if (.player == w.player)
						return;
					if (w.InHolder)
						return;
					if (.Goto(w, 150, 5000, true, 2500)) {
						if (!w.IsAlive)
							return;
						if (.player == w.player)
							return;
						if (w.InHolder)
							return;
						if (!.IsEnemy(w))
							if (!w.IsEnemy(this)) {//allied players management (note that it's different from using DiplAreAllied)
								w.SetPlayer(.player);
								return;
							}
						if (w.loyalty <= 0) {
							w.SetPlayer(.player);
							return;
						}
						if (.IsEnemy(w))
							UserNotification("unit attacked", "", w.pos, w.player);
						else if (w.IsEnemy(this))
							UserNotification("unit attacked", "", w.pos, w.player);

						if (!.IsVisible)
							.SetVisible(true);
						if (.HasSpecial(sneak))
							.SetLastAttackTime();

						.Face(w.pos);
						.Taunt(2000);
						if (.IsEnemy(w))//loyalty sometimes decreases even after the capture
							w.DecreaseLoyalty(1);
					}
				}
			}
			else if (u.IsHeirOf("WildHorse"))
				if (IsResearched(.player, "Tame horses")) {
					Unit h;

					h = u.AsUnit();

					while (h.IsAlive) {
						if (.player == h.player)
							return;
						if (h.InHolder)
							return;
						if (.Goto(h, 150, 5000, true, 2500)) {
							if (!h.IsAlive) 
								return;
							if (.player == h.player) 
								return;
							if (h.InHolder)
								return;
							if (!.IsEnemy(h))
								if (!h.IsEnemy(this)) {//allied players management (note that it's different from using DiplAreAllied)
									h.SetPlayer(.player);
									return;
								}
							if (.IsEnemy(h))
								UserNotification("unit attacked", "", h.pos, h.player);
							else if (h.IsEnemy(this))
								UserNotification("unit attacked", "", h.pos, h.player);

							if (!.IsVisible)
								.SetVisible(true);
							if (.HasSpecial(sneak))
								.SetLastAttackTime();
							
							.Face(h.pos);
							.Taunt(2000);

							if (h.IsAlive) {
								if (h.command != "move")
									h.SetCommand("move", .pos);
								if (h.player != .player) {
									h.SetPlayer(.player);
									UserNotification("horse captured", "", h.pos, h.player);
								}
							}
						}
					}
				}
		}
	Sleep(15);
}