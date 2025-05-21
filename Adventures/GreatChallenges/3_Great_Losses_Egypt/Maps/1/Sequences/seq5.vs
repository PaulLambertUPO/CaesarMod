int move_all_to, move_1_to, move_2_to;

while (1) {
	Sleep(10000);
	if (Attackers.IsEmpty()) {
		move_all_to = 0;
		move_1_to = 0;
		move_2_to = 0;
	}
	if (EnvReadInt("/En_Direction") == 2) {
		if (move_1_to < 1)
			if (!Intersect(AreaObjs("A_MovePointA1", cMilitary), Attackers1).IsEmpty())
				move_1_to = 1;
		if (move_1_to < 2)
			if (!Intersect(AreaObjs("A_MovePointA2", cMilitary), Attackers1).IsEmpty())
				move_1_to = 2;
		if (move_2_to < 3)
			if (!Intersect(AreaObjs("A_MovePointB1", cMilitary), Attackers2).IsEmpty())
				move_2_to = 3;
		if (move_2_to < 4)
			if (!Intersect(AreaObjs("A_MovePointB2", cMilitary), Attackers2).IsEmpty())
				move_2_to = 4;
		if (move_all_to < 5)
			if (!Intersect(AreaObjs("A_MovePointCenter", cMilitary), Attackers).IsEmpty())
				move_all_to = 5;
		if (move_all_to < 6)
			if (!Intersect(AreaObjs("A_AdvanceB1", cMilitary), Attackers).IsEmpty())
				move_all_to = 6;
		if (move_all_to < 7)
			if (!Intersect(AreaObjs("A_AdvanceB2", cMilitary), Attackers).IsEmpty())
				move_all_to = 7;
		if (move_all_to < 8)
			if (!Intersect(AreaObjs("A_AdvanceB3", cMilitary), Attackers).IsEmpty())
				move_all_to = 8;
		if (move_all_to < 9)
			if (!Intersect(AreaObjs("A_AdvanceB4", cMilitary), Attackers).IsEmpty())
				move_all_to = 9;
		if (!Intersect(AreaObjs("A_AdvanceB5", cMilitary), Attackers).IsEmpty()) {
			RunAIHelper("CaptureVillage1", "siege", "Attackers", "S_Village1");
			while (!Attackers.IsEmpty() && Village1.obj.player != 4)
				Sleep(1000);
			if (move_all_to < 10)
				move_all_to = 10;
		}
		if (!Intersect(AreaObjs("A_AdvanceB6", cMilitary), Attackers).IsEmpty()) {
			RunAIHelper("CaptureVillage2", "siege", "Attackers", "S_Village2" );
			while (!Attackers.IsEmpty() && Village2.obj.player != 4)
				Sleep(1000);
			if (move_all_to < 11)
				move_all_to = 11;
		}
		if (move_all_to < 12)
			if (!Intersect(AreaObjs("A_AdvanceB7", cMilitary), Attackers).IsEmpty())
				move_all_to = 12;
		if (!Intersect(AreaObjs("A_AdvanceB8", cMilitary), Attackers).IsEmpty())
			if (Union(UnitsInSettlement("S_Town", cMilitary), ClassPlayerAreaObjs(cMilitary, 1, "A_Annihilate")).count < Attackers.count / 2) {
				if (!IsAIHelperRunning("CaptureTown"))
					RunAIHelper("CaptureTown", "siege", "Attackers", "S_Town");
				while (!Attackers.IsEmpty() && Town.obj.player != 4)
					Sleep(1000);
			}
	}
	if (move_all_to == 0) {
		if (move_1_to == 1)
			AttackArea(Attackers1, "A_MovePointA2");
		else if (move_1_to == 2)
			AttackArea(Attackers1, "A_MovePointCenter");
		if (move_2_to == 3)
			AttackArea(Attackers2, "A_MovePointB2");
		else if (move_2_to == 4)
			AttackArea(Attackers2, "A_MovePointCenter");
	}
	else if (move_all_to == 5)
		AttackArea(Attackers, "A_AdvanceB1");
	else if (move_all_to == 6)
		AttackArea(Attackers, "A_AdvanceB2");
	else if (move_all_to == 7)
		AttackArea(Attackers, "A_AdvanceB3");
	else if (move_all_to == 8)
		AttackArea(Attackers, "A_AdvanceB4");
	else if (move_all_to == 9)
		AttackArea(Attackers, "A_AdvanceB5");
	else if (move_all_to == 10)
		AttackArea(Attackers, "A_AdvanceB6");
	else if (move_all_to == 11)
		AttackArea(Attackers, "A_AdvanceB7");
	else if (move_all_to == 12)
		AttackArea(Attackers, "A_AdvanceB8");
}