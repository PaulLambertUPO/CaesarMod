Obj shipyard;
int timer;

shipyard = NO_AthensShipyard.obj;

while (1) {
	Sleep(20000);
	timer -= 20000;
	if (timer <= 0) {
		timer = 300000;
		if (shipyard.player != 1)
			SpawnGroup("H_Boats");
	}
	if (!H_Boats.IsEmpty())
		if (shipyard.player != 1)
			H_Boats.SetCommand("unload", shipyard);
		else
			H_Boats.Damage(20000);
}