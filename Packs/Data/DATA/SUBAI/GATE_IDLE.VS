//void, Obj gate

Gate this;

this = gate.AsGate();

if (!.IsValid)
	while(1)
  		Sleep(100000);

while (1) {
	.LookAround(350);
	if (.AreEnemiesAround())
		.CloseNow();
	else if (.AreFriendsAround())
		.OpenNow();
	else
		.CloseNow();
	Sleep(500);
}