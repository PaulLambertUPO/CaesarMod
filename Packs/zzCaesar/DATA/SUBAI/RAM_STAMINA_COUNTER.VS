//void, Obj This

while (!This.IsValid)
	Sleep(1000);

This.AsUnit().SetNoAIFlag(true);

while (This.stamina > 0) {
	Sleep(5000);
	This.SetStamina(This.stamina - 1);
}

This.Damage(This.health);

//without this instruction, the game crashes
while (1)
	Sleep(3600000);