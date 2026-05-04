//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		point pt;

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else {
				if (.AI)
					if (.hero.IsDead) {//find the nearest owned reachable shipyard that can still host fishermen, otherwise convert to peasant
						ObjList ol;
						Obj o;
						int i, lsa;

						ol = GetSettlements("BaseShipyard", .player);
						lsa = .LSA;

						for (i = ol.count - 1; i >= 0; i -= 1) {
							o = ol[i];
							if (o.LSA != lsa)
								ol.Remove(o);
							else if (EnvReadInt(o.AsBuilding().settlement, "Fishermen") >= 50)
								ol.Remove(o);
						}

						if (ol.count > 0) {
							.SetCommand("enter", ol.FilterClosest(.pos, 1)[0]);
							break;
						}

						.Mutate("BVillager");//this is managed by "SquadMonitor.vs" (idle peasants are sent to the nearest stronghold)
					}

				if (.Stop(2000)) {
					.Idle(2000);
					if (rand(10) == 0) {
						pt = .GetDir();
						pt.SetLen(100);
						pt.Rot(30 - rand(61));
						.Face(pt + .pos);
					}
				}
			}
	}

Sleep(30);//prevent possible loops with other commands