SpawnGroupInHolder("T_Guards", "AI_Settlement");

T_BrotherHoodOfDead.SetCommand("attach", Guard1);
T_PretorianGuards.SetCommand("attach", Guard2);
T_Gladiators.SetCommand("attach", Guard3);

while (BlackOulderum.obj.player == 8) {
	if (Intersect(AreaObjs("A_ReadyToGuard", "Unit"), EnemyObjs(8, "Unit")).IsEmpty())
		if (T_Guards.InHolder("AI_Settlement") < T_Guards.count) {
			if (!T_Liberati.IsEmpty())
				T_Liberati.SetCommand("enter", BlackOulderum);
			if (!T_PretorianGuards.IsEmpty())
				T_PretorianGuards.SetCommand("enter", BlackOulderum);
			if (!T_Gladiators.IsEmpty())
				T_Gladiators.SetCommand("enter", BlackOulderum);
			if (!T_BrotherHoodOfDead.IsEmpty())
				T_BrotherHoodOfDead.SetCommand("enter", BlackOulderum);
		}
	Sleep(10000);
}