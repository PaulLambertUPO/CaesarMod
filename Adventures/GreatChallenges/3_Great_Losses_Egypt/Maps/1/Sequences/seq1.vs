ObjList ol_units;
int difficulty, current_wave, i, j;

difficulty = GetDifficulty();

Sleep(1000);

while (BadGuys1.obj.player == 4) {
	current_wave += 1;
	if (current_wave < 11) {
		if (current_wave < 4) {
			i = rand(3) + 1;
			j = rand(3) + 1;
		}
		else if (current_wave < 8) {
			i = rand(4) + 4;
			j = rand(4) + 4;
		}
		else {
			i = rand(3) + 8;
			j = rand(3) + 8;
		}
		SpawnGroupInHolder("BG" + i, "S_BadGuys1").AddToGroup("Attackers1");
		SpawnGroupInHolder("HeroRight" + current_wave, "S_BadGuys1").AddToGroup("Attackers1");
		Group("BG" + i).SetCommand("attach", Group("HeroRight" + current_wave).GetObjList()[0]);
		Group("BG" + i).RemoveFromGroup("BG" + i);
		Sleep(500);
		SpawnGroupInHolder("BG" + j, "S_BadGuys2").AddToGroup("Attackers2");
		SpawnGroupInHolder("HeroLeft" + current_wave, "S_BadGuys2").AddToGroup("Attackers2");
		Group("BG" + j).SetCommand("attach", Group("HeroLeft" + current_wave).GetObjList()[0]);
		Group("BG" + j).RemoveFromGroup("BG" + j);
		Sleep(500);
		Attackers1.AddToGroup("Attackers");
		Attackers2.AddToGroup("Attackers");
		Sleep(500);
		ol_units = Attackers.GetObjList();
		ol_units.ClearDead();
		j = ol_units.count;
		if (current_wave < 4)
			for (i = 0; i < j; i += 1)
				if (ol_units[i].AsHero().IsValid)
					ol_units[i].AsHero().SetAutocast(true);
				else
					ol_units[i].AsUnit().SetLevel(2 + difficulty * 2);
		else if (current_wave < 7)
			for (i = 0; i < j; i += 1)
				if (ol_units[i].AsHero().IsValid)
					ol_units[i].AsHero().SetAutocast(true);
				else {
					ol_units[i].AddItem("God's Gift");
					ol_units[i].AsUnit().SetLevel(6 + difficulty * 2);
				}
		else if (current_wave < 11)
			for (i = 0; i < j; i += 1)
				if (ol_units[i].AsHero().IsValid)
					ol_units[i].AsHero().SetAutocast(true);
				else {
					ol_units[i].AddItem("God's Gift");
					ol_units[i].AddItem("Veteran Offence");
					ol_units[i].AddItem("Veteran Defence");
					ol_units[i].AddItem("Veteran Health");
					ol_units[i].AsUnit().SetLevel(10 + difficulty * 2);
				}
		if (current_wave == 4) {
			Conversation conv;
			Unit u;
			if (!GoodHero.IsEmpty())
				u = GoodHero.obj.AsUnit();
			else if (!GoodHero2.IsEmpty())
				u = GoodHero2.obj.AsUnit();
			else
				u = GetPlayerUnits(1, cMilitary)[0].AsUnit();
			conv.Init("C_Conv5");
			conv.SetActor("Reporter", u);
			conv.Run();
			DiplShareView(1, 4, true);
			DiplShareView(4, 1, true);
		}
		else if (current_wave == 7) {
			RunConv("C_Conv6");
			Sleep(100);
			ol_units = SpawnGroup("Defenders_Left");
			j = ol_units.count;
			for (i = 0; i < j; i += 1) {
				ol_units[i].AddItem("Bear teeth amulet");
				ol_units[i].AddItem("Belt of might");
				CreateFeedback("Lightning3", ol_units[i].AsUnit());
			}
			ol_units = SpawnGroup("Defenders_Right");
			j = ol_units.count;
			for (i = 0; i < j; i += 1) {
				ol_units[i].AddItem("Bear teeth amulet");
				ol_units[i].AddItem("Belt of might");
				CreateFeedback("Lightning3", ol_units[i].AsUnit());
			}
			if (!IsAIHelperRunning("GuardArea_Left"))
				RunAIHelper("GuardArea_Left", "guard area", "Defenders_Left", "A_AdvanceB3");
			if (!IsAIHelperRunning("GuardArea_Right"))
				RunAIHelper("GuardArea_Right", "guard area", "Defenders_Right", "A_AdvanceA3");
		}
	}
	else {
		if (current_wave == 11) {
			RunConv("C_Conv7");
			GiveNote("Capture Memphis.");
			GiveNote("Capture Saqqara.");
			GetSettlement("S_BadGuys1").AllowCapture(true);
			GetSettlement("S_BadGuys2").AllowCapture(true);
			SpawnGroupInHolder("Final", "S_BadGuys1");
			SpawnGroupInHolder("HeroFinal", "S_BadGuys1").AddToGroup("Final");
			Final.SetCommand("attach", HeroFinal.GetObjList()[0]);
			ol_units = Final.GetObjList();
			Sleep(500);
			ol_units.ClearDead();
			j = ol_units.count;
			for (i = 0; i < j; i += 1)
				if (ol_units[i].AsHero().IsValid)
					ol_units[i].AsHero().SetAutocast(true);
				else {
					ol_units[i].AddItem("God's Gift");
					ol_units[i].AddItem("Veteran Offence");
					ol_units[i].AddItem("Veteran Defence");
					ol_units[i].AddItem("Veteran Health");
				}
			Sleep(100);
			ol_units = SpawnGroup("Defenders_Left");
			j = ol_units.count;
			for (i = 0; i < j; i += 1) {
				if (!ol_units[i].HasItem("Bear teeth amulet"))
					ol_units[i].AddItem("Bear teeth amulet");
				if (!ol_units[i].HasItem("Belt of might"))
					ol_units[i].AddItem("Belt of might");
				CreateFeedback("Lightning3", ol_units[i].AsUnit());
			}
			ol_units = SpawnGroup("Defenders_Right");
			j = ol_units.count;
			for (i = 0; i < j; i += 1) {
				if (!ol_units[i].HasItem("Bear teeth amulet"))
					ol_units[i].AddItem("Bear teeth amulet");
				if (!ol_units[i].HasItem("Belt of might"))
					ol_units[i].AddItem("Belt of might");
				CreateFeedback("Lightning3", ol_units[i].AsUnit());
			}
			if (!IsAIHelperRunning("GuardArea_Left"))
				RunAIHelper("GuardArea_Left", "guard area", "Defenders_Left", "A_AdvanceB3");
			if (!IsAIHelperRunning("GuardArea_Right"))
				RunAIHelper("GuardArea_Right", "guard area", "Defenders_Right", "A_AdvanceA3");
		}
		if (BG2Town.obj.player == 4) {
			i = rand(3) + 8;
			j = rand(3) + 8;
			SpawnGroupInHolder("BG" + j, "S_BadGuys2").AddToGroup("Attackers2");
			SpawnGroupInHolder("HeroLeft" + i, "S_BadGuys2").AddToGroup("Attackers2");
			Group("BG" + j).SetCommand("attach", Group("HeroLeft" + i).GetObjList()[0]);
			Group("BG" + j).RemoveFromGroup("BG" + j);
			Attackers2.AddToGroup("Attackers");
			Sleep(500);
			ol_units = Attackers.GetObjList();
			ol_units.ClearDead();
			j = ol_units.count;
			Sleep(500);
			for (i = 0; i < j; i += 1)
				if (ol_units[i].AsHero().IsValid())
					ol_units[i].AsHero().SetAutocast(true);
				else {
					ol_units[i].AddItem("God's Gift");
					ol_units[i].AddItem("Veteran Offence");
					ol_units[i].AddItem("Veteran Defence");
					ol_units[i].AddItem("Veteran Health");
					ol_units[i].AsUnit().SetLevel(10 + difficulty * 2);
				}
		}
		else if (IsNoteActive("Capture Saqqara."))
			RemoveNote("Capture Saqqara.");
	}
	EnvWriteInt("/En_Direction", rand(3));
	AttackArea(Attackers1, "A_MovePointA1");
	AttackArea(Attackers2, "A_MovePointB1");
	WaitEmptyQuery(Attackers, -1);
	Sleep(15000);
}