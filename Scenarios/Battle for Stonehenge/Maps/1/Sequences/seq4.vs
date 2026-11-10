Obj hall;

hall = BlackOulderum;

SpawnGroupInHolder("T_Guards", hall);

T_BrotherHoodOfDead.SetCommand("attach", Guard1);
T_PretorianGuards.SetCommand("attach", Guard2);
T_Gladiators.SetCommand("attach", Guard3);

while (hall.player == 8) {
	if (Intersect(AreaObjs("A_ReadyToGuard", "Unit"), EnemyObjs(8, "Unit")).IsEmpty)
		if (T_Guards.InHolder("AI_Settlement") < T_Guards.count)
			T_Guards.SetCommand("enter", hall);
	Sleep(10000);
}