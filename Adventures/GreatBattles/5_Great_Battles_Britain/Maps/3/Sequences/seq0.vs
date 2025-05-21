Query guards;
Building bld;
str set_name, set_guards, area_name, ai_helper;
int i;

Sleep(2000);

while (1) {
	for (i = 2; i <= 37; i += 1) {
		bld = GetNamedObj("NO_" + i).obj.AsBuilding();
		set_name = bld.settlement.name;
		set_guards = "T_" + set_name;
		area_name = "A_" + set_name;
		ai_helper = "AIG_" + set_name;
		guards = Group(set_guards);
		if (!guards.IsEmpty())
			if (Union(
						Intersect(EnemyObjs(bld.player, "Unit"), AreaObjs(area_name, "Unit")),
						Intersect(EnemyObjs(bld.player, "Catapult"), AreaObjs(area_name, "Catapult"))
					).IsEmpty()) {
				if (IsAIHelperRunning(ai_helper))
					StopAIHelper(ai_helper);
				if (!bld.IsHeirOf("BaseVillage"))
					if (guards.InHolder(set_name) < guards.count)
						guards.SetCommand("enter", bld);
			}
			else if (!IsAIHelperRunning(ai_helper))
				RunAIHelper(ai_helper, "guard area", set_guards, area_name);
		Sleep(50);
	}
	Sleep(4000);
}