int i, a;

while (Q_FinalWave.IsEmpty()) {
	Sleep(1000);
	for (i = 1; i <= 3; i += 1) {
		a = EnvReadInt("/En_MidArea" + i);
		if (!Intersect(
					AreaObjs("A_MidRomanDest" + a, cMilitary),
					Union(Group("Q_RomansMidHero" + i), Group("Q_RomansMid" + i))
				).IsEmpty()) {
			Sleep(4000);
			a += 1;
			EnvWriteInt("/En_MidArea" + i, MIN(a, 13));

			if (a > 13) {
				Sleep(20000);
				if (!Group("Q_RomansMid" + i).IsEmpty())
					Group("Q_RomansMid" + i).RemoveFromGroup("Q_RomansMid" + i);
				if (!Group("Q_RomansMidHero" + i).IsEmpty())
					Group("Q_RomansMidHero" + i).RemoveFromGroup("Q_RomansMidHero" + i);
				break;
			}

			if (!Group("Q_RomansMidHero" + i).IsEmpty())
				Group("Q_RomansMidHero" + i).SetCommand("attack", AreaCenter("A_MidRomanDest" + a));
			else if (!Group("Q_RomansMid" + i).IsEmpty())
				AttackArea(Group("Q_RomansMid" + i), "A_MidRomanDest" + a);
			else if (a != 1)
				EnvWriteInt("/En_MidArea" + i, 1);
		}
		else if (a != 1)
			if (Group("Q_RomansMidHero" + i).IsEmpty())
				if (!Group("Q_RomansMid" + i).IsEmpty())
					AttackArea(Group("Q_RomansMid" + i), "A_MidRomanDest" + a);
	}
}