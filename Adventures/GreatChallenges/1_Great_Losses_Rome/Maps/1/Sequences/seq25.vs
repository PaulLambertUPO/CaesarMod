int destination = 1;
bool forward = false;

Sleep(1000);

while (!Q_DawnPatrol2.IsEmpty()) {
	if (!Intersect(AreaObjs("A_SecondPatrol1", cMilitary), Q_DawnPatrol2).IsEmpty()) {
		destination = 2;
		forward = !forward;
	}
	else if (!Intersect(AreaObjs("A_SecondPatrol3", cMilitary), Q_DawnPatrol2).IsEmpty()) {
		destination = 2;
		forward = !forward;
	}
	else if (!Intersect(AreaObjs("A_SecondPatrol2", cMilitary), Q_DawnPatrol2).IsEmpty())
		if (forward)
			destination = 3;
		else
			destination = 1;

	if (!Q_PatrolingHero2.IsEmpty())
		Q_PatrolingHero2.SetCommand("attack", AreaCenter("A_SecondPatrol" + destination));
	else if (!Q_PatrolingForce2.IsEmpty())
		AttackArea(Q_DawnPatrol2, "A_SecondPatrol" + destination);

	Sleep(10000);
}