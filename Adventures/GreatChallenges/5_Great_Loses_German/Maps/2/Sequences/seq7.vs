int i, a;

while (Q_FinalWave.IsEmpty()) {
	Sleep(1000);
	for (i = 1; i <= 3; i += 1) {
		a = EnvReadInt("/En_DownArea" + i);
		if (!Intersect(
					AreaObjs("A_DownRomanDest" + a, cMilitary),
					Union(Group("Q_RomansDownHero" + i), Group("Q_RomansDown" + i))
				).IsEmpty()) {
			Sleep(4000);
			a += 1;
			EnvWriteInt("/En_DownArea" + i, MIN(a, 15));

			if (a > 15) {
				Sleep(20000);
				if (!Group("Q_RomansDown" + i).IsEmpty())
					Group("Q_RomansDown" + i).RemoveFromGroup("Q_RomansDown" + i);
				if (!Group("Q_RomansDownHero" + i).IsEmpty())
					Group("Q_RomansDownHero" + i).RemoveFromGroup("Q_RomansDownHero" + i);
				break;
			}

			if (!Group("Q_RomansDownHero" + i).IsEmpty())
				Group("Q_RomansDownHero" + i).SetCommand("attack", AreaCenter("A_DownRomanDest" + a));
			else if (!Group("Q_RomansDown" + i).IsEmpty())
				AttackArea(Group("Q_RomansDown" + i), "A_DownRomanDest" + a);
			else if (a != 1)
				EnvWriteInt("/En_DownArea" + i, 1);
		}
		else if (a != 1)
			if (Group("Q_RomansDownHero" + i).IsEmpty())
				if (!Group("Q_RomansDown" + i).IsEmpty())
					AttackArea(Group("Q_RomansDown" + i), "A_DownRomanDest" + a);
	}
}