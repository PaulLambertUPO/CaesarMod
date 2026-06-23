WaitQueryCountBetween(Subtract(ClassPlayerAreaObjs(cUnit, 1, "A_SkeletonAmbush"), ClassPlayerAreaObjs(cBaseAnimal, 1, "A_SkeletonAmbush")), 1, -1, -1);

{
	ObjList ol;
	Unit u;
	int i;

	SpawnGroup("SkeletonAmbush");

	ol = SkeletonGuards.GetObjList();
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsValid) {
			u.AddItem("Charm of Athena");
			u.AddItem("God's Gift");
		}
	}

	RunAIHelper("AmbushSkeleton", "guard area", "SkeletonGuards", "A_SkeletonAmbush");
}