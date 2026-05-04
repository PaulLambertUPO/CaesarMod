//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other != this) {
			Unit u;

			u = other.AsUnit();

			if (u.IsValid)
				if (u.IsAlive)
					if (!u.InHolder) {
						int talk_dist;

						talk_dist = MAX(100, .sight - 100);

						while (!.Goto(u, talk_dist, 5000, false, 15000))
							if (u.InHolder)
								break;

						if (u.IsAlive)
							if (!u.InHolder)
								EndConvSetup(this, u);
					}
		}

Sleep(30);//prevent possible loops with other commands