//void, Obj This

Sleep(250 + rand(251));

{
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		while (.IsAlive) {
			Sleep(20000 + rand(10001));
			if (.AI)
				if (.HasSpecial(cripple))
					.ExecCmd("cripple_to_penetration", .pos, this, false);
				else if (.HasSpecial(penetration))
					.ExecCmd("penetration_to_cripple", .pos, this, false);
		}
}

//without this instruction, the game crashes
while (true)
	Sleep(86400000);