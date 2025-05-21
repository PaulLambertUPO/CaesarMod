ObjList ol;
Settlement settle_town;
int time_1, time_2, time_3, i;
bool first_time = true;

settle_town = GetSettlement("Lindum");

settle_town.AllowCapture(false);
GetSettlement("Native village").AllowCapture(false);
GetSettlement("Dumnorium").AllowCapture(false);

//1 - move praetorians
LockView();

Sleep(500);
RunConv("1 Welcome");
GiveNote("Selection");
GiveNote("Commands1");
SetShortcutSel(1, 1, G1.GetObjList());

time_1 = GetTime() + 10000;
while (!WaitUnitsInArea(G1, "A_CampFire", 200)) {
	if (GetTime() > time_1) {
		RunConv("1 Welcome");
		time_1 = GetTime() + 5000;
	}
	ol = Intersect(AreaObjs("A_CampExit", "Military"), G1).GetObjList();
	for (i = 0; i < ol.count; i += 1)
		ol[i].SetPos(GetRandomPointInArea("A_CampStart"));
}
Sleep(2000);

G2.SetCommandOffset("move", AreaCenter("A_RuinsInner"));

UnlockView();

//2 - ruins ambush
RunConv("2A Navigation");
ExploreArea(1, "A_RuinsOuter");
GiveNote("Scrolling");
GiveNote("Minimap");

time_1 = GetTime() + 50000;
while (!WaitUnitsInArea(G1, "A_RuinsInner", 200)) {
	if (GetTime() > time_1) {
		RunConv("2A Navigation");
		time_1 = GetTime() + 20000;
	}
	if (first_time)
		if (!Intersect(AreaObjs("A_CampExit", "Military"), G1).IsEmpty()) {
			first_time = false;
			Instructor.obj.SetVisible(false);
			Instructor.obj.SetPos(AreaCenter("A_CampExit"));
			RunConv("2B Fog");
			Instructor.obj.SetPos(AreaCenter("A_RuinsInner"));
			GiveNote("Fog");
		}
}

WaitIdle(G2, 10000);

SpawnGroup("Enemies1");
Sleep(3000);
RunConv("2C Ambush");

WaitEmptyQuery(Enemies1, -1);

//3 - capture village
Sleep(500);
G2.AddToGroup("G1");
G2.SetPlayer(1);
SetShortcutSel(1, 1, G1.GetObjList());
Sleep(500);
RunConv("3A Capture");
GiveNote("Settlements");
GiveNote("Capturing");
GiveNote("Colors");
ExploreArea(1, "A_Village1");
ExploreArea(1, "A_Village2");
GetSettlement("Native village").AllowCapture(true);
Village.obj.AsBuilding().settlement.SetLoyalty(30);

time_1 = GetTime() + 70000;
first_time = true;
while (Village.obj.player != 1) {
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("3A Capture");
		time_1 = GetTime() + 20000;
	}
	if (first_time)
		if (Village.obj.AsBuilding().settlement.loyalty < 30) {
			Instructor.obj.SetPos(AreaCenter("A_VillageHall"));
			ClearSelection(1);
			Village.obj.Select(1);
			RunConv("3B Loyalty");
			GiveNote("Loyalty");
			GiveNote("InfoArea");
			first_time = false;
		}
}
Sleep(2000);

//4 - Caesar arrives
ol = G1.GetObjList();
ol.ClearDead();
for (i = 0; i < ol.count; i += 1)
	if (ol[i].DistTo(AreaCenter("A_VillageHall")) > 500)
		ol[i].SetPos(GetRandomPointInArea("A_VillageHall"));

SpawnGroup("Enemies2");
Enemies2.SetCommand("attach", EHero2);
EHero2.SetCommand("attack", AreaCenter("A_CampFire"));
CampDefense.SetCommand("attack", AreaCenter("A_CampAttack"));
Sleep(2000);
ClearSelection(1);
EHero2.obj.Select(1);

BlockUserInput();

Instructor.obj.SetPos(AreaCenter("A_CampAttack"));
RunConv("4A Camp attack");
GiveNote("Heroes");
GiveNote("Experience");

while (!CampDefense.IsEmpty())
	if (WaitEmptyQuery(Enemies2, 200))
		break;

UnblockUserInput();
Sleep(2000);

SpawnNamed("Caesar");
View(AreaCenter("A_VillageHall"), false);
Instructor.obj.SetPos(AreaCenter("A_VillageHall"));
RunConv("4B Caesar arrival");
GiveNote("Caesar must survive");
GiveNote("HeroSkills");

SetShortcutSel(1, 1, Caesar.GetObjList());

time_1 = GetTime() + 10000;
while (Caesar.obj.AsHero().army.count < G1.count) {
	Sleep(200);
	if (GetTime() > time_1) {
		ol = G1.GetObjList();
		ol.ClearDead();
		for (i = 0; i < ol.count; i += 1)
			if (ol[i].DistTo(AreaCenter("A_VillageHall")) > 500)
				ol[i].SetPos(GetRandomPointInArea("A_VillageHall"));
		RunConv("4B Caesar arrival");
		time_1 = GetTime() + 5000;
	}
}

RunConv("4C Retake camp");
GiveNote("Help");

Instructor.obj.SetPos(AreaCenter("A_CampAttack"));

time_1 = GetTime() + 150000;
time_2 = GetTime() + 10000;
while (!Enemies2.IsEmpty()) {
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("4C Retake camp");
		time_1 = GetTime() + 30000;
	}
	if (GetTime() > time_2) {
		ol = G1.GetObjList();
		ol.ClearDead();
		for (i = 0; i < ol.count; i += 1)
			if (!ol[i].AsUnit().hero.IsValid)
				ol[i].SetCommand("attach", Caesar);
		Enemies2.SetCommand("attack", AreaCenter("A_CampFire"));
		time_2 = GetTime() + 10000;
	}
}
Sleep(2000);

//5 - neutral outpost
RunConv("5A Take outpost");
GiveNote("Outposts");
ExploreArea(1, "A_Outpost");
EnvWriteInt("/AllowOutpost", 1);
Sleep(10000);

ol = Union(Caesar, G1).GetObjList();
ol.ClearDead();
for (i = 0; i < ol.count; i += 1) {
	ol[i].AsUnit().SetFeeding(true);
	ol[i].AsUnit().SetFood(1);
}
Caesar.SetCommand("idle");
Sleep(1500);
RunConv("5B Feed");
GiveNote("Food1");

time_1 = GetTime() + 60000;
while (Caesar.obj.AsUnit().food <= 1) {
	Sleep(200);
	Union(Caesar, G1).SetCommand("idle");
	if (GetTime() > time_1) {
		RunConv("5B Feed");
		time_1 = GetTime + 30000;
	}
}
Sleep(2000);

RunConv("5C Fed");
Instructor.obj.SetPos(AreaCenter("A_NearPost"));

time_1 = GetTime + 150000;
while (Post.obj.player != 1) {
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("5A Take outpost");
		time_1 = GetTime + 30000;
	}
	if (Post.obj.player >= 2)
		if (Post.obj.player <= 5)
			Post.SetPlayer(1);
}
Sleep(2000);

//6 - stronghold management
settle_town.SetPlayer(2);
RunConv("6A Stronghold");
ExploreArea(1, "A_Lindum");

time_1 = GetTime() + 90000;
while (!settle_town.Units.Contains(Caesar)) {
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("6A Stronghold");
		time_1 = GetTime() + 20000;
	}
}
Sleep(2000);

Instructor.obj.SetPos(AreaCenter("A_Lindum"));

RunConv("6B Build army");
GiveNote("ShelteredUnits");
GiveNote("EquipWarriors");

settle_town.SetPlayer(1);
settle_town.SetGold(5000);

time_1 = GetTime() + 300000;
time_2 = GetTime() + 1000;
time_3 = GetTime() + 3000;
first_time = true;
while (Count(1, cMilitary) - Count(1, cSentry) - 1 < 50) {//the 1 is Caesar (other heroes do not count)
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("6B Build army");
		time_1 = GetTime() + 120000;
	}
	if (GetTime() > time_2) {
		Subtract(ClassPlayerObjs("Military", 1), ClassPlayerObjs("Sentry", 1)).SetCommand("enter", LindumTownhall);
		time_2 = GetTime() + 1000;
	}
	if (GetTime() > time_3)
		if (settle_town.food <= 50)
			if (!(GetSettlement("Native village").supplied == settle_town))
				if (!(GetSettlement("Neutral post").supplied == settle_town)) {
					RunConv("6C Supply routes");
					if (!IsNoteActive("Food2"))
						GiveNote("Food2");
					time_3 = GetTime() + 10000;
				}
	if (first_time)
		if (settle_town.gold <= 400) {
			RunConv("6D Gold and population");
			GiveNote("Gold");
			GiveNote("Commands2");
			first_time = false;
		}
}
Sleep(2000);

//7 - final siege
RunConv("7A Attack town");
ExploreArea(1, "A_Dumnorium");
SpawnGroupInHolder("Enemies3", "Dumnorium");
GetSettlement("Dumnorium").AllowCapture(true);

Sleep(5000);
RunConv("7B Unit specials");
GiveNote("UnitSpecials");

Sleep(5000);
RunConv("7C Shortcuts");
GiveNote("Shortcuts");

time_1 = GetTime() + 300000;
first_time = true;
while (ETownhall.obj.player != 1) {
	Sleep(200);
	if (GetTime() > time_1) {
		RunConv("7A Attack town");
		time_1 = GetTime() + 90000;
	}
	if (first_time)
		if (!Union(ClassPlayerAreaObjs(cMilitary, 1, "A_Gate1"), ClassPlayerAreaObjs(cMilitary, 1, "A_Gate2")).IsEmpty()) {
			RunConv("7D Siege");
			GiveNote("Sieges");
			first_time = false;
		}
}

//8 - final speech
Sleep(5000);
RunConv("8 End");
Sleep(2000);

EndGame(1, false, Translate("You've completed the tutorial!"));