Settlement elephant_fort;
ObjList ol;
Unit u;
int difficulty, i;

difficulty = GetDifficulty();

Sleep(500);

elephant_fort = GetSettlement("S_TributeFort");

while (1) {
	ClassPlayerAreaObjs(cPeasant, 1, "A_Sacrifice").SetPlayer(3);
	ol = ClassPlayerAreaObjs(cPeasant, 3, "A_Sacrifice").GetObjList();
	ol.ClearDead();
	if (ol.count >= 50) {
		RunConv("C_Conv3");
		View(AreaCenter("A_MovePointCenter"), false);
		for (i = 0; i < 50; i += 1)
			ol[i].Damage(1000);
		ol = SpawnGroup("GodsGift");
		for (i = 0; i < ol.count; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid) {
				u.AddItem("Damage charm");
				u.AddItem("Armor charm");
				u.AddItem("Health charm");
				u.AddItem("Knowledge charm");
				u.SetLevel(50 - difficulty * 10);
				CreateFeedback("Lightning3", u);
			}
		}
		if (!IsAIHelperRunning("GuardCentralArea"))
			RunAIHelper("GuardCentralArea", "guard area", "GodsGift", "A_MovePointCenter");
	}
	if (elephant_fort.food >= 10000) {
		ol = SpawnGroupInHolder("Elephants", "S_TributeFort");
		for (i = 0; i < ol.count; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				u.SetLevel(18 - difficulty * 6);
		}
		ol.SetCommand("attack", AreaCenter("A_Elephants"));
		ol.RemoveFromAllGroups();
		elephant_fort.SetFood(elephant_fort.food - 10000);
	}
	if (elephant_fort.gold >= 5000) {
		ol = SpawnGroupInHolder("Elephants", "S_TributeFort");
		for (i = 0; i < ol.count; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				u.SetLevel(18 - difficulty * 6);
		}
		ol.SetCommand("attack", AreaCenter("A_Elephants"));
		ol.RemoveFromAllGroups();
		elephant_fort.SetGold(elephant_fort.gold - 5000);
	}
	Sleep(1000);
}