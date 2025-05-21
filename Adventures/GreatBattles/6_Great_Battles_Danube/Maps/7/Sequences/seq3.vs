int i;

while (1) {
	Sleep(30000);
	for (i = 1; i <= 7; i += 1)
		if (GetNamedObj("NO_Village" + i).obj.player != 4)
			if (!ClassPlayerAreaObjs(cMilitary, 4, "A_Village" + i).IsEmpty())
				if (ClassPlayerAreaObjs(cMilitary, 1, "A_Village" + i).IsEmpty())
					if (ClassPlayerAreaObjs(cMilitary, 2, "A_Village" + i).IsEmpty())
						if (i != 7)
							GetNamedObj("NO_Village" + i).SetPlayer(4);
						else if (UnitsInSettlement("S_Town", cMilitary).IsEmpty())
							GetNamedObj("NO_Village" + i).SetPlayer(4);
						else
							AttackArea(UnitsInSettlement("S_Town", cMilitary), "A_Village7");
}