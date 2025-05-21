ObjList ol_ranged, ol_melee, ol_temp;
int difficulty, i, j;

difficulty = GetDifficulty();

while (Q_FinalWave.IsEmpty()) {
	if (WaitQueryCountBetween(Intersect(AreaObjs("A_MidRomanDest7", cMilitary), Q_SpawnInvaders), 1, 1000, 1000)) {
		ol_ranged = UnitsInSettlement("S_MidOutpost", cRanged).GetObjList();
		ol_melee = UnitsInSettlement("S_MidOutpost", cMelee).GetObjList();
		if (ol_ranged.count + ol_melee.count > 0) {
			ol_ranged.SetPlayer(3);
			ol_melee.SetPlayer(3);
			ol_ranged.AddToGroup("Q_MidTemp");
			ol_melee.AddToGroup("Q_MidTemp");
			Sleep(10000);
			View(AreaCenter("A_MidRomanDest6"), false);
			ol_ranged.ClearDead();
			ol_melee.ClearDead();
			j = 1;
			for (i = 0; i < ol_ranged.count; i += 1) {
				ol_ranged[i].AsUnit().SetLevel(ol_ranged[i].AsUnit().level + 26);
				ol_ranged[i].SetPos(AreaCenter("A_AmbushMidAPos" + j));
				j += 1;
				if (j > 25)
					j = 1;
			}
			j = 1;
			for (i = 0; i < ol_melee.count; i += 1) {
				ol_melee[i].AsUnit().SetLevel(ol_melee[i].AsUnit().level + 26);
				ol_melee[i].SetPos(AreaCenter("A_AmbushMidIPos" + j));
				j += 1;
				if (j > 12)
					j = 1;
			}
			AttackArea(Q_MidTemp, "A_MidRomanDest7");
			while (1) {
				Sleep(500);
				if (Q_MidTemp.IsEmpty())
					break;
				if (Q_RomansMidHero1.IsEmpty())
					if (Q_RomansMidHero2.IsEmpty())
						if (Q_RomansMidHero3.IsEmpty())
							if (Q_RomansMid1.IsEmpty())
								if (Q_RomansMid2.IsEmpty())
									if (Q_RomansMid3.IsEmpty())
										break;
			}
			if (!Q_MidTemp.IsEmpty()) {
				ol_temp = Q_MidTemp.GetObjList();
				ol_temp.SetPlayer(1);
				for (i = 0; i < ol_temp.count; i += 1)
					ol_temp[i].AsUnit().SetLevel(ol_temp[i].AsUnit().level - (24 + difficulty));
				ol_temp.SetCommand("enter", NO_MidOutpost);
				Q_MidTemp.RemoveFromAllGroups();
			}
		}
	}
}