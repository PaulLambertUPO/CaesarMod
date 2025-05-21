Hero h;
ObjList ol;
int i, captured_heroes, timer_first_blood;
bool all_captured = false, first_blood = false;

for (i = 1; i <= 5; i += 1) {
	h = GetNamedObj("NO_PatrolHero" + i).obj.AsHero();
	Group("T_PatrolArmy" + i).SetCommand("attach", h);
	h.AddCommand(true, "patrol", AreaCenter("A_Patrol" + i));
	h.SetAutocast(true);
	ol.Add(h);
}

timer_first_blood = 900000 - GetDifficulty() * 300000;

while (!all_captured) {
	Sleep(1000);
	if (!first_blood) {
		timer_first_blood -= 1000;
		if (timer_first_blood <= 0) {
			first_blood = true;
			RunSequence("FirstBlood");
		}
	}
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1) {
		h = ol[i].AsHero();
		if (h.IsValid) {
			if (h.army.count == 0) {
				Conversation conv;
				captured_heroes += 1;
				conv.Init("Caput" + captured_heroes);
				conv.SetActor("actor", h);
				Sleep(400);
				conv.Run();
				h.SetPlayer(1);
				h.SetAutocast(false);
				h.SetCommand("enter", NO_1);
				ol.Remove(h);
				if (captured_heroes == 1) {
					T_S_Sett4.SetPlayer(2);
					NO_4.SetPlayer(1);
				}
				else if (captured_heroes == 2) {
					T_S_Sett3.SetPlayer(2);
					NO_3.SetPlayer(1);
				}
				else if (captured_heroes == 3) {
					T_S_Sett34.SetPlayer(2);
					NO_34.SetPlayer(1);
				}
				else if (captured_heroes == 4) {
					T_S_Sett2.SetPlayer(2);
					NO_2.SetPlayer(1);
				}
				else {
					T_S_Sett5.SetPlayer(2);
					NO_5.SetPlayer(1);
				}
			}
		}
	}
	all_captured = ol.count <= 0;
}

RemoveNote("B_Chieftains");

if (!first_blood)
	RunSequence("FirstBlood");