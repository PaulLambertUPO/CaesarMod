int i;

DiplCeaseFire(1, 2, true);
DiplCeaseFire(2, 1, true);
DiplCeaseFire(1, 3, true);
DiplCeaseFire(3, 1, true);
DiplCeaseFire(2, 3, true);
DiplCeaseFire(3, 2, true);

DiplShareView(1, 2, true);
DiplShareView(2, 1, true);
DiplShareView(1, 3, true);
DiplShareView(3, 1, true);
DiplShareView(1, 8, true);
DiplShareView(8, 1, true);

DiplCeaseFire(4, 5, true);
DiplCeaseFire(5, 4, true);
DiplCeaseFire(4, 6, true);
DiplCeaseFire(6, 4, true);
DiplCeaseFire(5, 6, true);
DiplCeaseFire(6, 5, true);
DiplCeaseFire(4, 8, true);
DiplCeaseFire(8, 4, true);
DiplCeaseFire(5, 8, true);
DiplCeaseFire(8, 5, true);
DiplCeaseFire(6, 8, true);
DiplCeaseFire(8, 6, true);

EnvWriteInt("/En_AllowForbiddenArea", 0);
EnvWriteInt("/En_IberiansArrived", 0);
EnvWriteInt("/En_IberiansDied", 0);
EnvWriteInt("/En_UticaTaken", 0);
EnvWriteInt("/En_SyphaxAssault", 0);
EnvWriteInt("/En_HannibalDefeated", 0);

SpawnGroupInHolder("Q_EnemyTownDefenders", "S_Utica");
SpawnGroupInHolder("Q_CarthageOutpostDefenders1", "S_CarthageOutpost1");
SpawnGroupInHolder("Q_CarthageOutpostDefenders2", "S_CarthageOutpost2");
SpawnGroupInHolder("Q_HannibalForce1", "S_CarthageOutpost1");
SpawnGroupInHolder("Q_HannibalForce2", "S_CarthageOutpost2");

NO_Masinissa.obj.AsHero().SetAutocast(true);

NO_Utica.obj.AsBuilding().Research("Forge maces");
NO_Blacksmith.obj.CmdDisable("Strenghten Stronghold Defences I");
NO_Blacksmith.obj.CmdDisable("Strenghten Stronghold Defences II");

GetSettlement("S_ChartageOutpost1").AllowCapture(false);
GetSettlement("S_ChartageOutpost2").AllowCapture(false);
GetSettlement("S_Shipyard").AllowCapture(false);

for (i = 1; i <= 3; i += 1)
	GetNamedObj("NO_RomanShip" + i).SetCommand("move", AreaCenter("A_RomanShipDest" + i));

for (i = 1; i <= 5; i += 1) {
	GetNamedObj("NO_Village" + i).SetCommand("tribute", NO_Utica);
	Group("Q_EnemyCampPatrol" + i).SetCommand("patrol", AreaCenter("A_EnemyCampPatrol" + i));
}

Q_CamelsPatrol.SetCommand("patrol", AreaCenter("A_CamelsPatrol"));
Q_Interceptors4.SetCommand("patrol", AreaCenter("A_Interceptors4Patrol"));