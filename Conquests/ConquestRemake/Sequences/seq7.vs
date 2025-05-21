Settlement set;
ObjList hero_list;
Unit u;
point p;

set = GetSettlement("S_Town1");
p = set.GetCentralBuilding().pos;
p.Set(p.x, p.y - 150);

u = Place("Trader", p, 1).AsUnit();
u.AsWagon().SetGold(6000);
set.ForceAddUnit(u);

u = Place("Caesar", p, 1).AsUnit();
u.SetFeeding(false);
u.SetLevel(20);
set.ForceAddUnit(u);

hero_list.Add(u);

SetShortcutSel(1, 1, hero_list);