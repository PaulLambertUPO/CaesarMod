int destination = 1;
bool forward = false;

Sleep(1000);

while (!Q_DawnPatrol3.IsEmpty()) {
	if (!Intersect(AreaObjs("A_ThirdPatrol1", cMilitary), Q_DawnPatrol3).IsEmpty()) {
		destination = 2;
		forward = !forward;
	}
	else if (!Intersect(AreaObjs("A_ThirdPatrol2", cMilitary), Q_DawnPatrol3).IsEmpty())
		if (forward)
			destination = 3;
		else
			destination = 1;
	else if (!Intersect(AreaObjs("A_ThirdPatrol3", cMilitary), Q_DawnPatrol3).IsEmpty())
		if (forward)
			destination = 4;
		else
			destination = 2;
	else if (!Intersect(AreaObjs("A_ThirdPatrol4", cMilitary), Q_DawnPatrol3).IsEmpty()) {
		destination = 3;
		forward = !forward;
	}

	if (!Q_PatrolingHero3.IsEmpty())
		Q_PatrolingHero3.SetCommand("attack", AreaCenter("A_ThirdPatrol" + destination));
	else if (!Q_PatrolingForce3.IsEmpty())
		AttackArea(Q_DawnPatrol3, "A_ThirdPatrol" + destination);

	Sleep(10000);
}