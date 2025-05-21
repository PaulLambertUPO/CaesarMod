ObjList ol;
Unit u;
int i;

DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);
DiplCeaseFire(1, 6, true);
DiplCeaseFire(6, 1, true);
DiplShareSupport(1, 6, true);
DiplShareSupport(6, 1, true);
DiplShareView(1, 3, true);
DiplShareView(3, 1, true);
DiplShareView(1, 5, true);
DiplShareView(5, 1, true);

DiplCeaseFire(4, 2, true);
DiplCeaseFire(2, 4, true);
DiplShareSupport(4, 2, true);
DiplShareSupport(2, 4, true);
DiplShareView(2, 4, true);
DiplShareView(4, 2, true);

RunSequence("NavalBattle");

SpawnGroupInHolder("E_PelusioDefence", "S_Pelusio");

SpawnGroupInHolder("E_PatrolCrew1", E_PatrolShip1.obj);
SpawnGroupInHolder("E_PatrolCrew2", E_PatrolShip2.obj);
E_PatrolShip1.SetCommand("patrol", AreaCenter("A_PatrolShip1"));
E_PatrolShip2.SetCommand("patrol", AreaCenter("A_PatrolShip2"));

SpawnGroupInHolder("E_MarkAntonyArmy", "S_Alexandria");
E_MarkAntonyArmy.SetCommand("attach", E_MarkAntony);
E_MarkAntony.obj.AsHero().SetAutocast(true);

SpawnGroupInHolder("E_CleopatraArmy", "S_Alexandria");
E_CleopatraArmy.SetCommand("attach", E_Cleopatra);
E_Cleopatra.obj.AsHero().SetAutocast(true);

ol = E_AlexandriaDefence.GetObjList();
for (i = 0; i < ol.count; i += 1) {
	u = ol[i].AsUnit();
	u.AddItem("Damage charm");
	u.AddItem("Armor charm");
	u.AddItem("Health charm");
	u.AddItem("Knowledge charm");
}

egypt_shrine.obj.CmdDisable("sacrifice");
egypt_shrine.obj.CmdDisable("teuton_horde");