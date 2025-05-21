int destination = 1;
bool forward = false;

Sleep(1000);

while (!Q_DawnPatrol1.IsEmpty()) {
	if (!Intersect(AreaObjs("A_FirstPatrol1", cMilitary), Q_DawnPatrol1).IsEmpty()) {
		destination = 2;
		forward = !forward;
	}
	else if (!Intersect(AreaObjs("A_FirstPatrol3", cMilitary), Q_DawnPatrol1).IsEmpty()) {
		destination = 2;
		forward = !forward;
	}
	else if (!Intersect(AreaObjs("A_FirstPatrol2", cMilitary), Q_DawnPatrol1).IsEmpty())
		if (forward)
			destination = 3;
		else
			destination = 1;

	if (!Q_PatrolingHero1.IsEmpty())
		Q_PatrolingHero1.SetCommand("attack", AreaCenter("A_FirstPatrol" + destination));
	else if (!Q_PatrolingForce1.IsEmpty())
		AttackArea(Q_DawnPatrol1, "A_FirstPatrol" + destination);

	Sleep(10000);
}