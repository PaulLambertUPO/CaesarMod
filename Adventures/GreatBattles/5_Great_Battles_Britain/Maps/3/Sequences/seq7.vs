ObjList ol_ships, ol_units;
Ship sh;
int i, j;

while (1) {
	while (!T_AllShips.IsEmpty()) {
		for (i = 1; i <= 3; i += 1) {
			if (GetNamedObj("Sh_" + i).obj.player == 1)
				Group("T_Ships" + i).Damage(5000);
			ol_ships.AddList(Group("T_Ships" + i).GetObjList());
		}
		ol_ships.ClearDead();
		for (i = 0; i < ol_ships.count; i += 1) {
			sh = ol_ships[i].AsShip();
			if (sh.IsValid)
				if (sh.UnitsCount > 0)
					sh.SetCommand("unboardall", GetRandomPointInArea(StrMid(sh.name, 1, StrLen(sh.name))));
				else {
					sh.Damage(sh.maxhealth);
					ol_ships.Remove(sh);
				}
		}
		Sleep(2500);
	}
	if (!T_RGroups.IsEmpty()) {
		ol_units = T_RGroups.GetObjList();
		ol_units.ClearDead();
		for (j = 0; j < ol_units.count; j += 1)
			if (!ol_units[j].AsUnit().InHolder()) {
				ol_units[j].AsUnit().SetNoAIFlag(false);
				ol_units[j].RemoveFromAllGroups();
			}
	}
	Sleep(2500);
}