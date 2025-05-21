Obj o1, o2;
ObjList ol;
Conversation conv;
int i;
bool found = false;

ol = T_Hidden.GetObjList();

while (!found) {
	for (i = 0; i < ol.count; i += 1)
		if (!ObjsInSight(ol[i], cShipBattle).IsEmpty()) {
			conv.Init("ShipUraa");
			conv.SetActor("Loser", ol[i].AsUnit());
			conv.Run();
			found = true;
			break;
		}
	Sleep(1000);
}

WaitConvRequest(NO_Viriato, NO_Larax, -1, o1, o2);
RunConv("LaraxTalk");

EnvWriteInt("/En_LaraxFound", 1);

if (IsNoteActive("FindLarax"))
	RemoveNote("FindLarax");

T_Hidden.SetPlayer(1);