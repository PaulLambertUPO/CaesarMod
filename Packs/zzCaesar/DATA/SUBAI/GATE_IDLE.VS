//void, Obj gate

Gate this;

this = gate.AsGate();

while (true) {
	.LookAround(350);
	if (.AreEnemiesAround)
		.CloseNow();
	else if (.AreFriendsAround)
		.OpenNow();
	else
		.CloseNow();
	Sleep(500);
}