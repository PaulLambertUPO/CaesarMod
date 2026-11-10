//void, Obj This

if (This.IsAlive) {
	Sleep(This.GetStaminaDecTime());
	if (This.IsAlive)
		This.Damage(This.health);
}

//without this instruction, the game crashes
while (true)
	Sleep(86400000);