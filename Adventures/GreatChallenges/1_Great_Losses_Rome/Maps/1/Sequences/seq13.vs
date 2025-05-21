int difficulty, timer, r;
bool retake = false;

difficulty = GetDifficulty();

while (1) {
	while (timer < 50) {
		if (!retake)
			if (NO_Ostia.obj.player != 4) {
				RemoveNote("Capture Ostia.");
				SpawnGroup("Q_OstiaReinforcementRome");
				RunAIHelper("RetakeOstia", "siege", "Q_OstiaReinforcementRome", "S_Ostia");
				retake = true;
			}
		Sleep(6000);
		timer += 1;
	}
	timer = 0;
	if (NO_Ostia.obj.player == 4) {
		Sleep(120000 - difficulty * 60000);
		SpawnGroup("Q_ReinforcementBoat");
		Q_ReinforcementBoat.SetCommand("move", AreaCenter("A_BoatDest"));
		WaitQueryCountBetween(ClassPlayerAreaObjs(cShipL, 7, "A_ShipArrival"), 1, 1000, 15000);
		Sleep(5000);
		SpawnGroup("Q_OstiaReinforcementRome");
		Q_OstiaReinforcementRome.SetPlayer(4);
		if (NO_InnerTown2.obj.player == 4) {
			AttackArea(Q_OstiaReinforcementRome, "A_InnerRome2");
			Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
			Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
		}
		else if (NO_InnerTown3.obj.player == 4) {
			AttackArea(Q_OstiaReinforcementRome, "A_InnerRome3");
			Q_OstiaReinforcementRome.AddToGroup("Q_UpperHelper2");
			Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
		}
		else if (NO_InnerTown1.obj.player == 4) {
			AttackArea(Q_OstiaReinforcementRome, "A_InnerRome1");
			Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
			Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
		}
		else if (NO_OuterTown.obj.player == 4) {
			AttackArea(Q_OstiaReinforcementRome, "A_OuterRome");
			Q_OstiaReinforcementRome.AddToGroup("Q_LowerHelper2");
			Q_OstiaReinforcementRome.RemoveFromGroup("Q_OstiaReinforcementRome");
		}
		Sleep(5000);
		Q_ReinforcementBoat.SetCommand("move", AreaCenter("A_BoatFinalRun"));
		WaitQueryCountBetween(ClassPlayerAreaObjs(cShipL, 7, "A_BoatFinalRun"), 1, 1000, 15000);
		Q_ReinforcementBoat.Erase();
	}
	else {
		Sleep(difficulty * 60000);
		SpawnGroup("Q_ReinforcementBoat");
		Q_ReinforcementBoat.SetCommand("move", AreaCenter("A_BoatDest"));
		WaitQueryCountBetween(ClassPlayerAreaObjs(cShipL, 7, "A_ShipArrival"), 1, 1000, 20000);
		Sleep(5000);
		r = rand(100);
		if (r < 50) {
			SpawnGroup("Q_OstiaReinforcementCarthage1");
			Q_OstiaReinforcementCarthage1.SetPlayer(1);
			Q_OstiaReinforcementCarthage1.SetCommand("enter", NO_Ostia);
			Q_OstiaReinforcementCarthage1.RemoveFromGroup("Q_OstiaReinforcementCarthage1");
		}
		else if (r < 85) {
			SpawnGroup("Q_OstiaReinforcementCarthage2");
			Q_OstiaReinforcementCarthage2.SetPlayer(1);
			Q_OstiaReinforcementCarthage2.SetCommand("enter", NO_Ostia);
			Q_OstiaReinforcementCarthage2.RemoveFromGroup("Q_OstiaReinforcementCarthage2");
		}
		else {
			SpawnGroup("Q_OstiaReinforcementCarthage3");
			Q_OstiaReinforcementCarthage3.SetPlayer(1);
			Q_OstiaReinforcementCarthage3.SetCommand("enter", NO_Ostia);
			Q_OstiaReinforcementCarthage3.RemoveFromGroup("Q_OstiaReinforcementCarthage3");
		}
		Sleep(5000);
		Q_ReinforcementBoat.SetCommand("move", AreaCenter("A_BoatFinalRun"));
		WaitQueryCountBetween(ClassPlayerAreaObjs(cShipL, 7, "A_BoatFinalRun"), 1, 1000, 15000);
		Q_ReinforcementBoat.Erase();
	}
}