I_Patrolers1.SetCommand("patrol", AreaCenter("A_P1"));
I_Patrolers2.SetCommand("patrol", AreaCenter("A_P2"));
I_Patrolers3.SetCommand("patrol", AreaCenter("A_P3"));
I_Patrolers4.SetCommand("patrol", AreaCenter("A_P4"));

WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_LastStand"), 1, 1000, -1);

I_NumantiaDefence.SetCommand("advanceenter", NO_40);

{
	ObjList last_units;
	int i;

	last_units = SpawnGroupInHolder("I_LastStand", "S_40");
	last_units.SetCommand("attach", I_LastStandHero);
	I_LastStandHero.obj.AsHero().SetAutocast(true);

	for (i = 0; i < last_units.count; i += 1)
		last_units[i].AsUnit().AddItem("Veteran Medal");
}

while (I_LastStandHero.InHolder("S_40"))
	Sleep(500);

RunConv("LastStand");