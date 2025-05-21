ObjList ol;
int i;

while (EnvReadInt("/AllowOutpost") != 1) {
	ol = ClassPlayerAreaObjs("Military", 1, "A_Outpost").GetObjList();
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1)
		ol[i].SetPos(GetRandomPointInArea("A_PreventEarlyOutpost"));
	Sleep(200);
}