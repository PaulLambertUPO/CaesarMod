Conversation conv;
ObjList ol;
Obj messenger;
point p;
int i, dist = 33000;

WaitEnvIntBetween("/En_NewMessenger", 1, 1, -1);

SpawnGroup("Q_InvisibleMessengers");
ol = Q_InvisibleMessengers.GetObjList();
for (i = 0; i < ol.count; i += 1)
	if (ol[i].DistTo(NO_hero.obj.posRH) < dist) {
		dist = ol[i].DistTo(NO_hero.obj.posRH);
		messenger = ol[i];
	}
	else
		ol[i].Erase();

while (messenger.DistTo(NO_hero.obj.posRH) > 500) {
	Sleep(2000);
	messenger.SetCommand("move", NO_hero.obj.posRH);
}

conv.Init("C_Conv2");
conv.SetActor("NO_hero", NO_hero.obj.AsUnit());
conv.SetActor("NO_Invisible", messenger.AsUnit());
conv.Run();
GiveNote("The secret camp must not fall.");

messenger.SetCommand("enter", NO_MainCamp);

BlockUserInput();
SetFog(false);
p = ViewPos();
if (!Q_LowerAssaultHero.IsEmpty()) {
	View(Q_LowerAssaultHero.GetObjList()[0].posRH, false);
	Sleep(5000);
	View(p, false);
}
SetFog(true);
UnblockUserInput();

while (!Q_InvisibleMessengers.IsEmpty()) {
	Sleep(5000);
	if (!Intersect(UnitsInSettlement("S_MainCamp", cMilitary), Q_InvisibleMessengers).IsEmpty())
		Q_InvisibleMessengers.Erase();
}