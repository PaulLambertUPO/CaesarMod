WaitQueryCountBetween(Intersect(AreaObjs("A_FortifiedCamp", cMilitary), Union(Q_SpawnInvaders, Q_FinalWave)), 1, 1000, -1);
ClearNotes();
EndGame(1, true, Translate("The Romans have reached Bingium."));