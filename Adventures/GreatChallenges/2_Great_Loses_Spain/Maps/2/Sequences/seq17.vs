WaitQueryCountBetween(ClassPlayerAreaObjs(cUnit, 1, "A_RomanTown"), 1, 1000, -1);

SpawnGroupInHolder("T_BrutalArmy", "S_RomanTown").SetCommand("attach", BHero);
BHero.obj.AsUnit().SetLevel(MAX(50, NO_Viriato.obj.AsUnit().level + 5));
BHero.obj.AsHero().SetAutocast(true);

Sleep(2000);

WaitHealthBetween(BHero, 1, 45, -1);
RunConv("Surrender");