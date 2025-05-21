while (NO_Utica.obj.player != 1) {
	if (NO_Village1.obj.player == 1)
		if (NO_Village2.obj.player == 1)
			if (NO_Village3.obj.player == 1)
				if (NO_Village4.obj.player == 1)
					if (NO_Village5.obj.player == 1) {
						ObjList ol;
						Unit u;
						int i;
						GetSettlement("S_Utica").SetFood(0);
						ol = Q_EnemyTownDefenders.GetObjList();
						ol.ClearDead();
						for (i = 0; i < ol.count; i += 1) {
							u = ol[i].AsUnit();
							if (u.IsValid)
								u.SetFood(0);
						}
						ClassPlayerObjs(cWagon, 4).Damage(500);
						break;
					}
	Sleep(10000);
}
WaitSettlementCapture("S_Utica", 1, -1);
EnvWriteInt("/En_UticaTaken", 1);
if (IsNoteActive("City of Utica"))
	RemoveNote("City of Utica");