ObjList ol_ranged, ol_melee, ol_temp;
int difficulty, i, j;

difficulty = GetDifficulty();

while (Q_FinalWave.IsEmpty()) {
	if (WaitQueryCountBetween(Intersect(AreaObjs("A_UpRomanDest11", cMilitary), Q_SpawnInvaders), 1, 1000, 1000)) {
		ol_ranged = UnitsInSettlement("S_UpOutpost", cRanged).GetObjList();
		ol_melee = UnitsInSettlement("S_UpOutpost", cMelee).GetObjList();
		if (ol_ranged.count + ol_melee.count > 0) {
			ol_ranged.SetPlayer(3);
			ol_melee.SetPlayer(3);
			ol_ranged.AddToGroup("Q_UpTemp");
			ol_melee.AddToGroup("Q_UpTemp");
			Sleep(10000);
			View(AreaCenter("A_UpRomanDest10"), false);
			ol_ranged.ClearDead();
			ol_melee.ClearDead();
			j = 1;
			for (i = 0; i < ol_ranged.count; i += 1) {
				ol_ranged[i].AsUnit().SetLevel(ol_ranged[i].AsUnit().level + 26);
				ol_ranged[i].SetPos(AreaCenter("A_AmbushUpAPos" + j));
				j += 1;
				if (j > 25)
					j = 1;
			}
			j = 1;
			for (i = 0; i < ol_melee.count; i += 1) {
				ol_melee[i].AsUnit().SetLevel(ol_melee[i].AsUnit().level + 26);
				ol_melee[i].SetPos(AreaCenter("A_AmbushUpIPos" + j));
				j += 1;
				if (j > 15)
					j = 1;
			}
			AttackArea(Q_UpTemp, "A_UpRomanDest11");
			while (1) {
				Sleep(500);
				if (Q_UpTemp.IsEmpty())
					break;
				if (Q_RomansUpHero1.IsEmpty())
					if (Q_RomansUpHero2.IsEmpty())
						if (Q_RomansUpHero3.IsEmpty())
							if (Q_RomansUp1.IsEmpty())
								if (Q_RomansUp2.IsEmpty())
									if (Q_RomansUp3.IsEmpty())
										break;
			}
			if (!Q_UpTemp.IsEmpty()) {
				ol_temp = Q_UpTemp.GetObjList();
				ol_temp.SetPlayer(1);
				for (i = 0; i < ol_temp.count; i += 1)
					ol_temp[i].AsUnit().SetLevel(ol_temp[i].AsUnit().level - (24 + difficulty));
				ol_temp.SetCommand("enter", NO_UpOutpost);
				Q_UpTemp.RemoveFromAllGroups();
			}
		}
	}
}