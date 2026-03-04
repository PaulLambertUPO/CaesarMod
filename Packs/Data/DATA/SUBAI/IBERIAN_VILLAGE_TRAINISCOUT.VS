//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement set;
	point pt_dest;
	int i;

	set = .settlement;
	i = .radius;

	pt_dest.SetLen(rand(GetConst("VillageTrainPeasantRadius") - i) + i);
	pt_dest.Rot(rand(360));
	pt_dest = pt_dest + .pos;

	i = EnvReadInt(set, "EEE_IVillageNumberHorses");
	if (i > 0) {
		Place("IScout", .GetExitPoint(pt_dest, false), .player).SetCommand("move", pt_dest);
		EnvWriteInt(set, "EEE_IVillageNumberHorses", MAX(0, i - 1));
	}
}