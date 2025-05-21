WaitEnvIntBetween("/En_SendChasers", 1, 1, -1);
RunConv("C_Conv3");
SpawnGroupInHolder("Q_Chasing", "S_Town");
Q_ChasingHorses.SetCommand("attach", NO_Chasing);
NO_Chasing.SetCommand("attack", AreaCenter("A_Chasing"));