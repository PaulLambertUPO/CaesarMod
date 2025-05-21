ObjList outposts;
Conversation conv;
int i, r;
bool i_flag = false, c_flag = false;

for (i = 1; i <= 40; i += 1)
	if (GetSettlement("S_" + i).IsOutpost)
		outposts.Add(GetNamedObj("NO_" + i));

while (outposts.count > 0) {
	for (i = 0; i < outposts.count; i += 1) {
		if (outposts[i].player == 1) {
			if (outposts[i].IsHeirOf("IOutpost")) {
				r += 1;
				SpawnGroupInHolder("B_Prisoners" + r, outposts[i].AsBuilding().settlement.name);
				if (!i_flag) {
					conv.Init("FreePrisoners");
					conv.SetActor("Prisoner", Group("B_Prisoners" + r).GetObjList()[0].AsUnit());
					conv.Run();
					i_flag = true;
				}
			}
			else if (outposts[i].IsHeirOf("COutpost")) {
				GetNamedObj("CH_" + outposts[i].name).obj.AsItemHolder().AddItem("Healing water");
				SpawnGroupInHolder("B_Camel", outposts[i].AsBuilding().settlement.name);
				if (!c_flag) {
					conv.Init("FreshFood");
					conv.SetActor("Camel", Group("B_Camel").GetObjList()[0].AsUnit());
					conv.Run();
					Group("B_Camel").RemoveFromAllGroups();
					c_flag = true;
				}
			}
			else if (outposts[i].IsHeirOf("GOutpost")) {
				Unit u;
				point vect, pt;
				str chosen_unit;

				vect = Point(0, 600);
				vect.Rot(rand(361));
				pt = outposts[i].pos + vect;

				SpawnGroupInHolder("B_DarkGuy", outposts[i].AsBuilding().settlement.name);
				u = B_DarkGuy.GetObjList()[0].AsUnit();
				u.SetCommand("move", pt);
				Sleep(4000);

				conv.Init("Polymorph");
				conv.SetActor("DarkGuy", u);
				conv.Run();
				chosen_unit = ConvResult("Polymorph");
				SpawnGroupInHolder(chosen_unit, outposts[i].AsBuilding().settlement.name);
				u.SetCommand("idle");
				pt = u.pos;
				u.Erase();
				Group(chosen_unit).GetObjList()[0].AsUnit().SetPos(pt);
				Group(chosen_unit).RemoveFromAllGroups();
			}
			outposts.Remove(outposts[i]);
		}
	}
	Sleep(1500);
}