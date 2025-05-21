IntArray setts;
Hero h;
Obj obj;
int i, n;

setts[0] = 29;
setts[1] = 27;
setts[2] = 26;
setts[3] = 4;
setts[4] = 3;
setts[5] = 34;
setts[6] = 1;

SetFog(false);

SpawnGroup("T_CalgacusArmy");
EnvWriteInt("/CalgacusSpawned", 1);

Sleep(300);

for (i = 1; i <= 6; i += 1) {
	h = GetNamedObj("B_Hero" + i).obj.AsHero();
	Group("T_Block" + i).SetCommand("attach", h);
	h.SetAutocast(true);
}

Sleep(2000);

for (i = 0; i < 7; i += 1) {
	n = setts[i];
	obj = GetNamedObj("NO_" + n);
	if (obj.IsEnemy(T_CalgacusArmy.GetObjList()[0])) {
		RunAIHelper("Capture_S_Sett" + n, "siege", "T_CalgacusArmy", "S_Sett" + n);
		while (!T_CalgacusArmy.IsEmpty() && obj.IsEnemy(T_CalgacusArmy.GetObjList()[0])) {
			if (!IsAIHelperRunning("Capture_S_Sett" + n))
				RunAIHelper("Capture_S_Sett" + n, "siege", "T_CalgacusArmy", "S_Sett" + n);
			Sleep(2000);
		}
		Sleep(60000);
	}
	T_CalgacusArmy.Heal(2000);
	T_CalgacusArmy.HealStamina(10);
}