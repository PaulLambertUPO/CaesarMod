int i, carthage_interval, timer;
bool talked = false, ai_running = false;

carthage_interval = 480000 - GetDifficulty() * 60000;
timer = carthage_interval;

while (1) {
	Sleep(10000);
	timer -= 10000;
	if (timer <= 0) {
		timer = carthage_interval;
		SpawnGroup("C_Army1");
		SpawnGroup("C_Army2");
		if (!talked) {
			RunConv("DesertTribes");
			GiveNote("DesertTribes");
			talked = true;
		}
	}
	if (NO_Pelusio.obj.player == 5 || NO_Memphis.obj.player == 5 || NO_Alexandria.obj.player == 5) {
		if (!ai_running) {
			AIStart(5, "DEFAULT", 2);
			ai_running = true;
		}
		if (!C_Army.IsEmpty()) {
			SetNoAIFlag(C_Army.GetObjList(), false);
			C_Army.SetCommand("advanceenter", ClassPlayerObjs(cBaseTownhall, 5).GetObjList()[0]);
			C_Army.RemoveFromAllGroups();
		}
	}
	else if (!C_Army.IsEmpty()) {
		if (!C_Army1.IsEmpty())
			if (!IsAIHelperRunning("MainAttack"))
				RunAIHelper("MainAttack", "siege", "C_Army1", "S_Memphis");
		if (!C_Army2.IsEmpty())
			if (!IsAIHelperRunning("CavalryAttack"))
				if (rand(2) == 0) {
					for (i = 10; i >= 1; i -= 1)
						if (GetNamedObj("NO_V" + i).obj.player != 5) {
							RunAIHelper("CavalryAttack", "siege", "C_Army2", "S_V" + i);
							break;
						}
				}
				else
					for (i = 9; i >= 1; i -= 1)
						if (GetNamedObj("NO_O" + i).obj.player != 5) {
							RunAIHelper("CavalryAttack", "siege", "C_Army2", "S_O" + i);
							break;
						}
	}
	else if (ai_running) {
		AIStop(5);
		ai_running = false;
	}
}