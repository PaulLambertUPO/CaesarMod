Hero h;
int difficulty, i = 1;

difficulty = GetDifficulty();

while (1) {
	if (EnvReadInt("/NeedArmy") == 1) {
		SpawnGroupInHolder("T_RomArmy" + i, "S_RomanTown");
		SpawnGroupInHolder("T_RomeHero" + i, "S_RomanTown");
		h = GetNamedObj("RomeHero" + i).obj.AsHero();
		Group("T_RomArmy" + i).SetCommand("attach", h);
		h.SetAutocast(true);
		Sleep(1500);
		Group("T_RomArmy" + i).AddToGroup("VaniArmy");
		h.AddToGroup("VaniArmy");
		h.SetName("");
		EnvWriteInt("/NeedArmy", 0);
		if (rand(2) == 0)
			h.SetLevel(h.level + 2 + difficulty * 2);
		i += 1;
		if (i > 10)
			i = 1;
	}
	Sleep(2000);
}