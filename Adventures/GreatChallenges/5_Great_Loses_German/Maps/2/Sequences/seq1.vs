ObjList ol_tmp;
point p;
StrArray paths;
str path;
IntArray legion_movements;
int difficulty, waves, w, i, j;

paths[0] = "Down";
paths[1] = "Mid";
paths[2] = "Up";

difficulty = GetDifficulty();

Sleep(90000 - difficulty * 15000);

waves = 9 + difficulty * 3;

while (w < waves) {
	for (i = 0; i < 3; i += 1) {
		path = paths[i];
		if (Group("Q_Romans" + path + "Hero1").IsEmpty())
			if (Group("Q_Romans" + path + "Hero2").IsEmpty())
				if (Group("Q_Romans" + path + "Hero3").IsEmpty())
					if (Group("Q_Romans" + path + "1").IsEmpty())
						if (Group("Q_Romans" + path + "2").IsEmpty())
							if (Group("Q_Romans" + path + "3").IsEmpty()) {
								Sleep(90000);
								SpawnGroup("Q_SpawnInvaders");
								w += 1;
								EnvWriteInt("/En_" + path + "Area1", 1);
								EnvWriteInt("/En_" + path + "Area2", 1);
								EnvWriteInt("/En_" + path + "Area3", 1);
								Q_RomanHero1.AddToGroup("Q_Romans" + path + "Hero1");
								Q_RomanHero1.RemoveFromGroup("Q_RomanHero1");
								Q_RomanHero2.AddToGroup("Q_Romans" + path + "Hero2");
								Q_RomanHero2.RemoveFromGroup("Q_RomanHero2");
								Q_RomanHero3.AddToGroup("Q_Romans" + path + "Hero3");
								Q_RomanHero3.RemoveFromGroup("Q_RomanHero3");
								Q_PrinciplesInvaders.AddToGroup("Q_Romans" + path + "1");
								Q_PrinciplesInvaders.RemoveFromGroup("Q_PrinciplesInvaders");
								ol_tmp = Group("Q_Romans" + path + "1").GetObjList();
								for (j = 0; j < ol_tmp.count; j += 1)
									ol_tmp[j].AsUnit().SetLevel(15 + w / 2);
								ol_tmp.SetCommand("attach", Group("Q_Romans" + path + "Hero1").GetObjList[0]);
								Q_VelitiInvaders.AddToGroup("Q_Romans" + path + "2");
								Q_VelitiInvaders.RemoveFromGroup("Q_VelitiInvaders");
								ol_tmp = Group("Q_Romans" + path + "2").GetObjList();
								for (j = 0; j < ol_tmp.count; j += 1)
									ol_tmp[j].AsUnit().SetLevel(15 + w / 2);
								ol_tmp.SetCommand("attach", Group("Q_Romans" + path + "Hero2").GetObjList[0]);
								Q_HastatiInvaders.AddToGroup("Q_Romans" + path + "3");
								Q_HastatiInvaders.RemoveFromGroup("Q_HastatiInvaders");
								ol_tmp = Group("Q_Romans" + path + "3").GetObjList();
								for (j = 0; j < ol_tmp.count; j += 1)
									ol_tmp[j].AsUnit().SetLevel(15 + w / 2);
								ol_tmp.SetCommand("attach", Group("Q_Romans" + path + "Hero3").GetObjList[0]);
								Group("Q_Romans" + path + "Hero1").SetCommand("attack", AreaCenter("A_" + path + "RomanDest1"));
								Sleep(5000);
								Group("Q_Romans" + path + "Hero2").SetCommand("attack", AreaCenter("A_" + path + "RomanDest1"));
								Sleep(5000);
								Group("Q_Romans" + path + "Hero3").SetCommand("attack", AreaCenter("A_" + path + "RomanDest1"));
								Sleep(15000);
							}
	}
	Sleep(20000);
}

WaitEmptyQuery(Q_SpawnInvaders, -1);
Sleep(41000 - (difficulty * 20000));
SpawnGroup("Q_FinalLegion1");
Q_FinalLegion1.SetCommand("attach", NO_LegionLeader1);
NO_LegionLeader1.SetCommand("attack", AreaCenter("A_DownRomanDest1"));
Sleep(8000);
BlockUserInput();
p = ViewPos();
SetFog(false);
View(NO_LegionLeader1.obj.posRH, false);
Sleep(2000);
RunConv("C_Conv3");
Sleep(3000);
SpawnGroup("Q_FinalLegion2");
Q_Legion2.SetCommand("attach", NO_LegionLeader2);
NO_LegionLeader2.SetCommand("attack", AreaCenter("A_DownRomanDest1"));
Sleep(3000);
RunConv("C_Conv4");
RemoveNote("The captured outposts.");
RemoveNote("Deepwood ambush.");
RemoveNote("Northwood ambush.");
RemoveNote("Southwood ambush.");
GiveNote("The great ambush.");
SetFog(true);
View(p, false);
UnblockUserInput();
Sleep(6000);
SpawnGroup("Q_FinalLegion3");
Q_Legion3.SetCommand("attach", NO_LegionLeader3);
NO_LegionLeader3.SetCommand("attack", AreaCenter("A_DownRomanDest1"));
ol_tmp = Q_FinalWaveLevel.GetObjList();
for (i = 0; i < ol_tmp.count; i += 1)
	ol_tmp[i].AsUnit().SetLevel(ol_tmp[i].AsUnit().inherentlevel + difficulty * 5);

while (!Q_FinalWave.IsEmpty()) {
	for (i = 1; i <= 3; i += 1) {
		if (legion_movements[i] < 1)
			if (!Intersect(AreaObjs("A_DownRomanDest1", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 1;
		if (legion_movements[i] < 2)
			if (!Intersect(AreaObjs("A_DownRomanDest2", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 2;
		if (legion_movements[i] < 3)
			if (!Intersect(AreaObjs("A_DownRomanDest3", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 3;
		if (legion_movements[i] < 4)
			if (!Intersect(AreaObjs("A_Final4", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 4;
		if (legion_movements[i] < 5)
			if (!Intersect(AreaObjs("A_Final5", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 5;
		if (legion_movements[i] < 6)
			if (!Intersect(AreaObjs("A_Final6", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 6;
		if (legion_movements[i] < 7)
			if (!Intersect(AreaObjs("A_Final7", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 7;
		if (legion_movements[i] < 8)
			if (!Intersect(AreaObjs("A_Final8", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 8;
		if (legion_movements[i] < 9)
			if (!Intersect(AreaObjs("A_Final9", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 9;
		if (legion_movements[i] < 10)
			if (!Intersect(AreaObjs("A_MidRomanDest10", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 10;
		if (legion_movements[i] < 11)
			if (!Intersect(AreaObjs("A_MidRomanDest11", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 11;
		if (legion_movements[i] < 12)
			if (!Intersect(AreaObjs("A_MidRomanDest12", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 12;
		if (legion_movements[i] < 13)
			if (!Intersect(AreaObjs("A_MidRomanDest13", cMilitary), Group("Q_FinalLegion" + i)).IsEmpty())
				legion_movements[i] = 13;
		if (legion_movements[i] == 0) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_DownRomanDest1"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_DownRomanDest1");
		}
		else if (legion_movements[i] == 1) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_DownRomanDest2"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_DownRomanDest2");
		}
		else if (legion_movements[i] == 2) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_DownRomanDest3"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_DownRomanDest3");
		}
		else if (legion_movements[i] == 3) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final4"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final4");
		}
		else if (legion_movements[i] == 4) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final5"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final5");
		}
		else if (legion_movements[i] == 5) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final6"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final6");
		}
		else if (legion_movements[i] == 6) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final7"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final7");
		}
		else if (legion_movements[i] == 7) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final8"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final8");
		}
		else if (legion_movements[i] == 8) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_Final9"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_Final9");
		}
		else if (legion_movements[i] == 9) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_MidRomanDest10"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_MidRomanDest10");
		}
		else if (legion_movements[i] == 10) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_MidRomanDest11"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_MidRomanDest11");
		}
		else if (legion_movements[i] == 11) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_MidRomanDest12"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_MidRomanDest12");
		}
		else if (legion_movements[i] == 12) {
			if (!Group("Q_LegionLeader" + i).IsEmpty())
				Group("Q_LegionLeader" + i).SetCommand("attack", AreaCenter("A_MidRomanDest13"));
			else if (!Group("Q_Legion" + i).IsEmpty())
				AttackArea(Group("Q_Legion" + i), "A_MidRomanDest13");
		}
	}
	Sleep(10000);
}