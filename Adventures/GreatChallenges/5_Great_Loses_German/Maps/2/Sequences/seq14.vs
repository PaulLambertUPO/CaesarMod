ObjList ol_ranged, ol_melee;
int i, j;
bool ambush_started = false;

WaitQueryCountBetween(Q_FinalWave, 1, 1000, -1);

while (!Q_FinalWave.IsEmpty()) {
	if (!ambush_started)
		if (WaitQueryCountBetween(Intersect(AreaObjs("A_FinalAmbush", cMilitary), Q_FinalWave), 1, 1000, 1000)) {
			ol_ranged = Union(
				Union(UnitsInSettlement("S_UpOutpost", cRanged), UnitsInSettlement("S_MidOutpost", cRanged)),
				Union(UnitsInSettlement("S_DownOutpost", cRanged), UnitsInSettlement("S_MainCamp", cRanged))
			).GetObjList();
			ol_melee = Union(
				Union(UnitsInSettlement("S_UpOutpost", cMelee), UnitsInSettlement("S_MidOutpost", cMelee)),
				Union(UnitsInSettlement("S_DownOutpost", cMelee), UnitsInSettlement("S_MainCamp", cMelee))
			).GetObjList();
			if (ol_ranged.count + ol_melee.count > 0) {
				ol_ranged.SetPlayer(1);
				ol_melee.SetPlayer(1);
				ol_ranged.AddToGroup("Q_TheEnd");
				ol_melee.AddToGroup("Q_TheEnd");
				Sleep(5000);
				View(AreaCenter("A_FinalAmbush"), false);
				if (NO_hero.obj.AsUnit().InHolder()) {
					NO_hero.obj.AsHero().DetachArmy();
					NO_hero.obj.SetPos(AreaCenter("A_FinalAmbushArminius"));
					NO_hero.SetCommand("advance", AreaCenter("A_MidRomanDest12"));
				}
				ol_ranged.ClearDead();
				ol_melee.ClearDead();
				j = 1;
				for (i = 0; i < ol_ranged.count; i += 1) {
					ol_ranged[i].AsUnit().SetLevel(ol_ranged[i].AsUnit().level + 26);
					ol_ranged[i].SetPos(AreaCenter("A_FinalAAmbush" + j));
					j += 1;
					if (j > 29)
						j = 1;
				}
				j = 1;
				for (i = 0; i < ol_melee.count; i += 1) {
					ol_melee[i].AsUnit().SetLevel(ol_melee[i].AsUnit().level + 26);
					ol_melee[i].SetPos(AreaCenter("A_FinalIAmbush" + j));
					j += 1;
					if (j > 32)
						j = 1;
				}
				AttackArea(Q_TheEnd, "A_MidRomanDest12");
			}
			ambush_started = true;
		}
	Sleep(500);
}

ClearNotes();

PlayMovie(Translate("Movies/ENG/GreatChallenges/5_Extro_Great_L_German.avi"));

EndGame(1, false, Translate("You have annihilated three Roman legions!"));