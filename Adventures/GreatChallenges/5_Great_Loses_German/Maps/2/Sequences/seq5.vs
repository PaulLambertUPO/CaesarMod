ObjList ol_ranged, ol_melee, ol_temp;
int difficulty, i, j;

difficulty = GetDifficulty();

while (Q_FinalWave.IsEmpty()) {
	if (WaitQueryCountBetween(Intersect(AreaObjs("A_DownRomanDest7", cMilitary), Q_SpawnInvaders), 1, 1000, 1000)) {
		ol_ranged = UnitsInSettlement("S_DownOutpost", cRanged).GetObjList();
		ol_melee = UnitsInSettlement("S_DownOutpost", cMelee).GetObjList();
		if (ol_ranged.count + ol_melee.count > 0) {
			ol_ranged.SetPlayer(3);
			ol_melee.SetPlayer(3);
			ol_ranged.AddToGroup("Q_DownTemp");
			ol_melee.AddToGroup("Q_DownTemp");
			Sleep(10000);
			View(AreaCenter("A_DownRomanDest6"), false);
			ol_ranged.ClearDead();
			ol_melee.ClearDead();
			j = 1;
			for (i = 0; i < ol_ranged.count; i += 1) {
				ol_ranged[i].AsUnit().SetLevel(ol_ranged[i].AsUnit().level + 26);
				ol_ranged[i].SetPos(AreaCenter("A_AmbushDownAPos" + j));
				j += 1;
				if (j > 25)
					j = 1;
			}
			j = 1;
			for (i = 0; i < ol_melee.count; i += 1) {
				ol_melee[i].AsUnit().SetLevel(ol_melee[i].AsUnit().level + 26);
				ol_melee[i].SetPos(AreaCenter("A_AmbushDownIPos" + j));
				j += 1;
				if (j > 14)
					j = 1;
			}
			AttackArea(Q_DownTemp, "A_DownRomanDest7");
			while (1) {
				Sleep(500);
				if (Q_DownTemp.IsEmpty())
					break;
				if (Q_RomansDownHero1.IsEmpty())
					if (Q_RomansDownHero2.IsEmpty())
						if (Q_RomansDownHero3.IsEmpty())
							if (Q_RomansDown1.IsEmpty())
								if (Q_RomansDown2.IsEmpty())
									if (Q_RomansDown3.IsEmpty())
										break;
			}
			if (!Q_DownTemp.IsEmpty()) {
				ol_temp = Q_DownTemp.GetObjList();
				ol_temp.SetPlayer(1);
				for (i = 0; i < ol_temp.count; i += 1)
					ol_temp[i].AsUnit().SetLevel(ol_temp[i].AsUnit().level - (24 + difficulty));
				ol_temp.SetCommand("enter", NO_DownOutpost);
				Q_DownTemp.RemoveFromAllGroups();
			}
		}
	}
}