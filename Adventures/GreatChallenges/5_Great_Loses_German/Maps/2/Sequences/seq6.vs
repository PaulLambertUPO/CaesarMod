int i, a;

while (Q_FinalWave.IsEmpty()) {
	Sleep(1000);
	for (i = 1; i <= 3; i += 1) {
		a = EnvReadInt("/En_UpArea" + i);
		if (!Intersect(
					AreaObjs("A_UpRomanDest" + a, cMilitary),
					Union(Group("Q_RomansUpHero" + i), Group("Q_RomansUp" + i))
				).IsEmpty()) {
			Sleep(4000);
			a += 1;
			EnvWriteInt("/En_UpArea" + i, MIN(a, 20));

			if (a > 20) {
				Sleep(20000);
				if (!Group("Q_RomansUp" + i).IsEmpty())
					Group("Q_RomansUp" + i).RemoveFromGroup("Q_RomansUp" + i);
				if (!Group("Q_RomansUpHero" + i).IsEmpty())
					Group("Q_RomansUpHero" + i).RemoveFromGroup("Q_RomansUpHero" + i);
				break;
			}

			if (!Group("Q_RomansUpHero" + i).IsEmpty())
				Group("Q_RomansUpHero" + i).SetCommand("attack", AreaCenter("A_UpRomanDest" + a));
			else if (!Group("Q_RomansUp" + i).IsEmpty())
				AttackArea(Group("Q_RomansUp" + i), "A_UpRomanDest" + a);
			else if (a != 1)
				EnvWriteInt("/En_UpArea" + i, 1);
		}
		else if (a != 1)
			if (Group("Q_RomansUpHero" + i).IsEmpty())
				if (!Group("Q_RomansUp" + i).IsEmpty())
					AttackArea(Group("Q_RomansUp" + i), "A_UpRomanDest" + a);
	}
}