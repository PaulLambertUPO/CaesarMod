WaitQueryCountBetween(Intersect(EnemyObjs(4, cUnit), AreaObjs("A_AlexandriaDefence", cUnit)), 1, 1000, -1);

E_AlexandriaDefence.SetCommand("advanceenter", NO_Alexandria);
Sleep(5000);

while (!E_AlexandriaDefence.IsEmpty()) {
	if (Intersect(EnemyObjs(4, cUnit), AreaObjs("A_AlexandriaDefence", cUnit)).IsEmpty())
		if (E_AlexandriaDefence.InHolder("S_Alexandria") < E_AlexandriaDefence.count)
			E_AlexandriaDefence.SetCommand("enter", NO_Alexandria);
	Sleep(10000);
}