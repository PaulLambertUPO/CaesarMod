WaitSettlementCapture("S_5", 1, -1);

SpawnGroupInHolder("E_1", "S_5");

R_Scout.SetCommand("move", AreaCenter("A_Event1"));
Sleep(3500);
RunConv("Event1");
R_Scout.SetCommand("enter", NO_5);
Sleep(5000);
R_Scout.Erase();