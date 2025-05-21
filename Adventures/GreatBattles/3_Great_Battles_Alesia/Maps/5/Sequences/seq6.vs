int i;

while (1) {
	Sleep(30000);
	for (i = 1; i <= 8; i += 1)
		if (GetNamedObj("NO_FortificationPoint" + i).obj.player != 4)
			if (Union(
						ClassPlayerAreaObjs(cMilitary, 1, "A_RomanDefPoint" + i),
						ClassPlayerAreaObjs(cMilitary, 2, "A_RomanDefPoint" + i)
					).IsEmpty())
				if (!Union(
							ClassPlayerAreaObjs(cMilitary, 4, "A_RomanDefPoint" + i),
							ClassPlayerAreaObjs(cMilitary, 5, "A_RomanDefPoint" + i)
						).IsEmpty())
					if (i <= 4 && !UnitsInSettlement("S_FortificationPoint" + i, cMilitary).IsEmpty())
						AttackArea(UnitsInSettlement("S_FortificationPoint" + i, cMilitary), "A_RomanDefPoint" + i);
					else
						GetNamedObj("NO_FortificationPoint" + i).obj.SetPlayer(4);
}