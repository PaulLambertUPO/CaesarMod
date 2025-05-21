bool guard1 = false, guard2 = false, guard3 = false;

Q_Stonehenge1.SetCommand("stand_position");
Q_Stonehenge2.SetCommand("stand_position");
Q_Stonehenge3.SetCommand("stand_position");

while (!guard1 || !guard2 || !guard3) {
	Sleep(2000);
	if (!guard1)
		if (!Union(
					Union(
						ClassPlayerAreaObjs(cMilitary, 1, "A_Stonehenge1"),
						ClassPlayerAreaObjs(cMilitary, 7, "A_Stonehenge1")
					),
					ClassPlayerAreaObjs(cMilitary, 8, "A_Stonehenge1")
				).IsEmpty()) {
			RunAIHelper("Stonehenge1", "guard area", "Q_Stonehenge1", "A_Stonehenge1");
			guard1 = true;
		}
	if (!guard2)
		if (!Union(
					Union(
						ClassPlayerAreaObjs(cMilitary, 1, "A_Stonehenge2"),
						ClassPlayerAreaObjs(cMilitary, 7, "A_Stonehenge2")
					),
					ClassPlayerAreaObjs(cMilitary, 8, "A_Stonehenge2")
				).IsEmpty()) {
			RunAIHelper("Stonehenge2", "guard area", "Q_Stonehenge2", "A_Stonehenge2");
			guard2 = true;
		}
	if (!guard3)
		if (!Union(
					Union(
						ClassPlayerAreaObjs(cMilitary, 1, "A_Stonehenge3"),
						ClassPlayerAreaObjs(cMilitary, 7, "A_Stonehenge3")
					),
					ClassPlayerAreaObjs(cMilitary, 8, "A_Stonehenge3")
				).IsEmpty()) {
			RunAIHelper("Stonehenge3", "guard area", "Q_Stonehenge3", "A_Stonehenge3");
			guard3 = true;
		}
}