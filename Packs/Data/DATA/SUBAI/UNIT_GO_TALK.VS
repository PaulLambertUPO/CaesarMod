//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (other != this)
			if (other.AsUnit().IsValid)
				if (other.IsAlive) {
					int talk_dist;
					bool isMilitary;

					talk_dist = MAX(100, .sight - 100);
					isMilitary = .IsMilitary;

					while (!.Goto(other, talk_dist, 5000, isMilitary, 15000))
						;

					if (other.IsAlive)
						EndConvSetup(This, other);
				}