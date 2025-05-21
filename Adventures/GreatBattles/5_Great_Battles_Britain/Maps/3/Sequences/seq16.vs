Query group37, group29;

group37 = Group("Take_S_Sett37");
group29 = Group("Take_S_Sett29");

while (1) {
	if (NO_37.obj.player == 2)
		NO_37.SetPlayer(1);
	if (NO_29.obj.player == 2)
		NO_29.SetPlayer(1);
	if (!group37.IsEmpty())
		if (NO_37.obj.player == 1) {
			group37.AddToGroup("T_S_Sett37");
			group37.RemoveFromGroup("Take_S_Sett37");
		}
	if (!group29.IsEmpty())
		if (NO_29.obj.player == 1) {
			group29.AddToGroup("T_S_Sett29");
			group29.RemoveFromGroup("Take_S_Sett29");
		}
	Sleep(1000);
}