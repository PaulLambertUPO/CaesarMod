int move_1_to, move_2_to;

while (1) {
	Sleep(10000);
	if (!TempSiege.IsEmpty())
		if (Union(UnitsInSettlement("S_Town", cMilitary), ClassPlayerAreaObjs(cMilitary, 1, "A_Annihilate")).count < TempSiege.count / 2)
			if (!IsAIHelperRunning("CaptureTown"))
				RunAIHelper("CaptureTown", "siege", "TempSiege", "S_Town");
	if (Attackers.IsEmpty()) {
		move_1_to = 0;
		move_2_to = 0;
	}
	if (EnvReadInt("/En_Direction") == 0) {
		if (move_1_to < 1)
			if (!Intersect(AreaObjs("A_MovePointA1", cMilitary), Attackers1).IsEmpty())
				move_1_to = 1;
		if (move_2_to < 1)
			if (!Intersect(AreaObjs("A_MovePointB1", cMilitary), Attackers2).IsEmpty())
				move_2_to = 1;
		if (move_1_to < 2)
			if (!Intersect(AreaObjs("A_MovePointA2", cMilitary), Attackers1).IsEmpty())
				move_1_to = 2;
		if (move_2_to < 2)
			if (!Intersect(AreaObjs("A_MovePointB2", cMilitary), Attackers2).IsEmpty())
				move_2_to = 2;
		if (move_1_to < 3)
			if (!Intersect(AreaObjs("A_MovePointCenter", cMilitary), Attackers1).IsEmpty())
				move_1_to = 3;
		if (move_2_to < 3)
			if (!Intersect(AreaObjs("A_MovePointCenter", cMilitary), Attackers2).IsEmpty())
				move_2_to = 3;
		if (move_1_to < 4)
			if (!Intersect(AreaObjs("A_AdvanceA1", cMilitary), Attackers1).IsEmpty())
				move_1_to = 4;
		if (move_2_to < 4)
			if (!Intersect(AreaObjs("A_AdvanceB1", cMilitary), Attackers2).IsEmpty())
				move_2_to = 4;
		if (move_1_to < 5)
			if (!Intersect(AreaObjs("A_AdvanceA2", cMilitary), Attackers1).IsEmpty())
				move_1_to = 5;
		if (move_2_to < 5)
			if (!Intersect(AreaObjs("A_AdvanceB2", cMilitary), Attackers2).IsEmpty())
				move_2_to = 5;
		if (move_1_to < 6)
			if (!Intersect(AreaObjs("A_AdvanceA3", cMilitary), Attackers1).IsEmpty())
				move_1_to = 6;
		if (move_2_to < 6)
			if (!Intersect(AreaObjs("A_AdvanceB3", cMilitary), Attackers2).IsEmpty())
				move_2_to = 6;
		if (move_1_to < 7)
			if (!Intersect(AreaObjs("A_AdvanceA4", cMilitary), Attackers1).IsEmpty())
				move_1_to = 7;
		if (move_2_to < 7)
			if (!Intersect(AreaObjs("A_AdvanceB4", cMilitary), Attackers2).IsEmpty())
				move_2_to = 7;
		if (!Intersect(AreaObjs("A_AdvanceA5", cMilitary), Attackers1).IsEmpty()) {
			RunAIHelper("CaptureVillage3", "siege", "Attackers1", "S_Village3");
			while (!Attackers1.IsEmpty() && Village3.obj.player != 4)
				Sleep(1000);
			if (move_1_to < 8)
				move_1_to = 8;
		}
		if (!Intersect(AreaObjs("A_AdvanceB5", cMilitary), Attackers2).IsEmpty()) {
			RunAIHelper("CaptureVillage1", "siege", "Attackers2", "S_Village1");
			while (!Attackers2.IsEmpty() && Village1.obj.player != 4)
				Sleep(1000);
			if (move_2_to < 8)
				move_2_to = 8;
		}
		if (!Intersect(AreaObjs("A_AdvanceA6", cMilitary), Attackers1).IsEmpty()) {
			RunAIHelper("CaptureVillage4", "siege", "Attackers1", "S_Village4");
			while (!Attackers1.IsEmpty() && Village4.obj.player != 4)
				Sleep(1000);
			if (move_1_to < 9)
				move_1_to = 9;
		}
		if (!Intersect(AreaObjs("A_AdvanceB6", cMilitary), Attackers2).IsEmpty()) {
			RunAIHelper("CaptureVillage2", "siege", "Attackers2", "S_Village2");
			while (!Attackers2.IsEmpty() && Village2.obj.player != 4)
				Sleep(1000);
			if (move_2_to < 9)
				move_2_to = 9;
		}
		if (move_1_to < 10)
			if (!Intersect(AreaObjs("A_AdvanceA7", cMilitary), Attackers1).IsEmpty())
				move_1_to = 10;
		if (move_2_to < 10)
			if (!Intersect(AreaObjs("A_AdvanceB7", cMilitary), Attackers2).IsEmpty())
				move_2_to = 10;
		if (!Intersect(AreaObjs("A_AdvanceA8", cMilitary), Attackers1).IsEmpty()) {
			Attackers1.AddToGroup("TempSiege");
			Attackers1.RemoveFromGroup("Attackers1");
		}
		if (!Intersect(AreaObjs("A_AdvanceB8", cMilitary), Attackers2).IsEmpty()) {
			Attackers2.AddToGroup("TempSiege");
			Attackers2.RemoveFromGroup("Attackers2");
		}
	}
	if (move_1_to == 1)
		AttackArea(Attackers1, "A_MovePointA2");
	else if (move_1_to == 2)
		AttackArea(Attackers1, "A_MovePointCenter");
	else if (move_1_to == 3)
		AttackArea(Attackers1, "A_AdvanceA1");
	else if (move_1_to == 4)
		AttackArea(Attackers1, "A_AdvanceA2");
	else if (move_1_to == 5)
		AttackArea(Attackers1, "A_AdvanceA3");
	else if (move_1_to == 6)
		AttackArea(Attackers1, "A_AdvanceA4");
	else if (move_1_to == 7)
		AttackArea(Attackers1, "A_AdvanceA5");
	else if (move_1_to == 8)
		AttackArea(Attackers1, "A_AdvanceA6");
	else if (move_1_to == 9)
		AttackArea(Attackers1, "A_AdvanceA7");
	else if (move_1_to == 10)
		AttackArea(Attackers1, "A_AdvanceA8");
	if (move_2_to == 1)
		AttackArea(Attackers2, "A_MovePointB2");
	else if (move_2_to == 2)
		AttackArea(Attackers2, "A_MovePointCenter");
	else if (move_2_to == 3)
		AttackArea(Attackers2, "A_AdvanceB1");
	else if (move_2_to == 4)
		AttackArea(Attackers2, "A_AdvanceB2");
	else if (move_2_to == 5)
		AttackArea(Attackers2, "A_AdvanceB3");
	else if (move_2_to == 6)
		AttackArea(Attackers2, "A_AdvanceB4");
	else if (move_2_to == 7)
		AttackArea(Attackers2, "A_AdvanceB5");
	else if (move_2_to == 8)
		AttackArea(Attackers2, "A_AdvanceB6");
	else if (move_2_to == 9)
		AttackArea(Attackers2, "A_AdvanceB7");
	else if (move_2_to == 10)
		AttackArea(Attackers2, "A_AdvanceB8");
}