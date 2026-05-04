//void, Obj this, Obj other

if (.AsFlying().IsValid)
	if (.IsAlive)
		if (other != this) {
			Unit u;

			u = other.AsUnit();

			if (u.IsValid)
				if (u.IsAlive)
					if (!u.InHolder) {
						int talk_dist;

						talk_dist = MAX(100, .sight - 100);

						if (.DistTo(u) < talk_dist)
							EndConvSetup(this, u);
						else {
							.AddCommand(true, "go_talk", u);
							.AddCommand(true, "move", RandomPointInCircle(u.pos, talk_dist - 50));
						}
					}
		}

Sleep(30);//prevent possible loops with other commands