Q_PatrolingHero4.SetCommand("patrol", AreaCenter("A_FourthPatrol2"));
WaitEmptyQuery(Q_PatrolingHero4, -1);
if (!Q_PatrolingForce4.IsEmpty())
	Q_PatrolingForce4.SetCommand("patrol", AreaCenter("A_Ostia"));