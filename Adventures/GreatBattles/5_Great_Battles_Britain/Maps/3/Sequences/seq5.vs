SpawnGroup("T_FirstBlood").SetCommand("attach", BloodSeeker);
BloodSeeker.obj.AsHero().SetAutocast(true);
Sleep(1000);
RunAIHelper("FirstBlood", "siege", "T_FirstBlood", "S_Sett1");