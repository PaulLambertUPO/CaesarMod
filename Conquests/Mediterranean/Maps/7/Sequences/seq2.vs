bool guard1 = false, guard2 = false;

Q_Stonehenge1.SetCommand("stand_position");
Q_Stonehenge2.SetCommand("stand_position");

while (!guard1 || !guard2) {
	Sleep(2000);
	if (!guard1)
		if (!ClassPlayerAreaObjs(cMilitary, 1, "A_Stonehenge1").IsEmpty()) {
			RunAIHelper("Stonehenge1", "guard area", "Q_Stonehenge1", "A_Stonehenge1");
			guard1 = true;
		}
	if (!guard2)
		if (!ClassPlayerAreaObjs(cMilitary, 1, "A_Stonehenge2").IsEmpty()) {
			RunAIHelper("Stonehenge2", "guard area", "Q_Stonehenge2", "A_Stonehenge2");
			guard2 = true;
		}
}