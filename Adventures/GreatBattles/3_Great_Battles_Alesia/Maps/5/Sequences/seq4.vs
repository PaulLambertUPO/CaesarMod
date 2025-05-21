ObjList ol_intro_def, ol_intro_def1, ol_intro_def2, ol_intro_att1, ol_intro_att2;
int i;

BlockUserInput();

NO_MessengerIntro.SetCommand("move", NO_Caesar.obj.posRH + Point(0, 250));
Sleep(3000);
SpawnGroup("Q_IntroEscort1");
Q_IntroEscort1.SetCommand("move", NO_MessengerIntro.obj.pos);
Sleep(1500);
Q_IntroEscort1.SetCommand("move", NO_MessengerIntro.obj.pos);
Sleep(1500);
View(AreaCenter("A_IntroGathering"), true);
SpawnGroup("Q_IntroEscort1");
Q_IntroEscort1.SetCommand("move", NO_MessengerIntro.obj.pos);
Q_IntroEscort3.SetCommand("move", NO_MessengerIntro.obj.pos);
Q_IntroGWest1.SetCommand("move", AreaCenter("A_IntroDest1"));
Q_IntroGWest1.AddCommand(true, "move", AreaCenter("A_IntroDest2"));
Q_IntroGWest1.AddCommand(false, "move", AreaCenter("A_IntroDest3"));
Q_IntroGWest1.AddCommand(false, "move", AreaCenter("A_IntroDest4"));
Q_IntroGWest2.SetCommand("move", AreaCenter("A_IntroDest1"));
Q_IntroGWest2.AddCommand(true, "move", AreaCenter("A_IntroDest2"));
Q_IntroGWest2.AddCommand(false, "move", AreaCenter("A_IntroDest3"));
Q_IntroGWest2.AddCommand(false, "move", AreaCenter("A_IntroDest4"));
Q_IntroGWest3.SetCommand("move", AreaCenter("A_IntroView1"));
Q_IntroGWest3.AddCommand(true, "move", AreaCenter("A_IntroDest3"));
Q_IntroGWest3.AddCommand(false, "move", AreaCenter("A_IntroDest4"));
Sleep(1500);
SpawnGroup("Q_IntroEscort1");
Q_IntroEscort1.SetCommand("move", NO_MessengerIntro.obj.pos);
Q_IntroEscort3.SetCommand("move", NO_MessengerIntro.obj.pos);
Sleep(1500);
MoveToArea(Q_IntroEscort1, "A_IntroGathering");
MoveToArea(Q_IntroEscort3, "A_IntroGathering");
AttackArea(Q_IntroGWest4, "A_IntroGaulInfDest");
RunConv("Intro");
NO_Hero1.SetCommand("attack", AreaCenter("A_IntroDest5"));
Q_HeroArmy1.SetCommand("attach", NO_Hero1);
AttackArea(Q_IntroGEast1, "A_RomanDefPoint2");
AttackArea(Q_IntroGEast3, "A_ExtraPosition");
AttackArea(Q_IntroReinforcement, "A_ExtraPosition");
Q_HeroArmy2.SetCommand("attach", NO_Hero2);
Q_IntroGEast2.SetCommand("attack", NO_Hero2.obj.posRH);
Sleep(1000);
View(AreaCenter("A_IntroGathering"), false);

UnblockUserInput();

GiveNote("Julius Caesar must survive");
GiveNote("Keep the siege positions");
GiveNote("CaptureAlesia1");

Q_IntroEscort1.SetCommand("attach", NO_Caesar);
SpawnGroup("Q_IntroEscort2").SetCommand("attach", NO_Caesar);
Q_IntroEscort3.SetCommand("attach", NO_Caesar);
Q_IntroEscort4.SetCommand("attach", NO_Caesar);
ol_intro_def = SpawnGroup("Q_IntroDef");
ol_intro_def2 = SpawnGroup("Q_IntroDef2");
for (i = 0; i < ol_intro_def.count; i += 1) {
	ol_intro_def[i].SetCommand("move", AreaCenter("A_InsideIntroCamp1") + Point(i * 50, i * 20));
	ol_intro_def[i].AddCommand(false, "stand_position");
}
for (i = 0; i < ol_intro_def2.count; i += 1) {
	ol_intro_def2[i].SetCommand("move", AreaCenter("A_InsideIntroCamp2") + Point(i * 50, i * 20));
	ol_intro_def2[i].AddCommand(false, "stand_position");
}
NO_Caesar.SetCommand("move", AreaCenter("A_LeaderMoveIntro1"));
NO_Caesar.AddCommand(false, "stand_position");
NO_Caesar.AddCommand(false, "move", AreaCenter("A_LeaderMoveIntro2"));
Sleep(3000);
NO_Hero2.SetCommand("attack", AreaCenter("A_IntroView4"));
Sleep(10000);
Q_FrontSupport.SetCommandOffset("move", AreaCenter("A_IntroGaulInfDest") + Point(50, 150));
Sleep(4000);
Q_FrontSupport.SetCommand("stand_position");
Sleep(2000);
SpawnGroup("Q_GaulHeadline");
Sleep(12000);
ol_intro_att1 = Q_IntroGWest1.GetObjList();
ol_intro_def1 = Q_IntroEscort1.GetObjList();
for (i = 0; i < ol_intro_att1.count; i += 1)
	ol_intro_att1[i].SetCommand("attack", ol_intro_def1[i]);
ol_intro_att2 = Q_IntroGWest2.GetObjList();
for (i = 0; i < ol_intro_att2.count; i += 1)
	ol_intro_att2[i].SetCommand("attack", ol_intro_def[i]);
Sleep(4000);
AttackArea(Q_IntroGWest3, "A_IntroCamp");
Sleep(60000);
SpawnGroupInHolder("Q_Escapers1", "S_GaulCentral");
SpawnGroupInHolder("Q_Escapers2", "S_GaulCentral");
AttackArea(Q_Escapers1, "A_Escape1");
AttackArea(Q_Escapers2, "A_Escape2");
Sleep(20000);

BlockUserInput();

NO_Caesar.SetMessengerStatus(true);
HideZoomMap();
SetFog(false);
View(AreaCenter("A_IntroView1"), true);
Sleep(5000);
View(AreaCenter("A_IntroView3"), true);
Sleep(5000);
View(AreaCenter("A_IntroView2"), false);
Sleep(10000);
View(AreaCenter("A_ExtraPosition"), false);
Sleep(8000);
SetFog(true);
NO_Caesar.SetMessengerStatus(false);

UnblockUserInput();

WaitQueryCountBetween(Intersect(ClassPlayerAreaObjs(cMilitary, 5, "A_AutoSpawn1"), Q_Escapers2), 1, 100, 5000);
HideZoomMap();
View(AreaCenter("A_AutoSpawn1") + Point(0, 200), false);

EnvWriteInt("/En_IntroEnds", 1);

while (!Q_Escapers1.IsEmpty() || !Q_Escapers2.IsEmpty()) {
	Sleep(2500);
	if (!Intersect(Q_Escapers1, AreaObjs("A_Escape1", cMilitary)).IsEmpty())
		Intersect(Q_Escapers1, AreaObjs("A_Escape1", cMilitary)).Erase();
	if (!Intersect(Q_Escapers2, AreaObjs("A_Escape2", cMilitary)).IsEmpty())
		Intersect(Q_Escapers2, AreaObjs("A_Escape2", cMilitary)).Erase();
}