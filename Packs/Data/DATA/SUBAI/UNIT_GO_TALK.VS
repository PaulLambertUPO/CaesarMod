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
						bool isMilitary;

						talk_dist = MAX(100, .sight - 100);
						isMilitary = .IsMilitary;

						while (!.Goto(u, talk_dist, 5000, isMilitary, 15000))
							if (u.InHolder)
								break;

						if (u.IsAlive)
							if (!u.InHolder)
								EndConvSetup(This, u);
					}
		}

Sleep(15);//prevent possible loops with other commands