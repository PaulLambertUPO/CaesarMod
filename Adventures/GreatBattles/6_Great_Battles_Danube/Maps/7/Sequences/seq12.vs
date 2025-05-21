int i;

WaitEnvIntBetween("/En_LocalResistenceSpotted", 1, 1, -1);
GiveNote("Talk with the locals");

WaitUnitsInArea(Q_Marcus, "A_NearPriest", -1);
RunConv("C_Conv5");
RemoveNote("Talk with the locals");
GiveNote("Teuton camp");

WaitSettlementCapture("S_Tent1", 1, -1);
WaitSettlementCapture("S_Tent2", 1, -1);
RemoveNote("Teuton camp");
DiplShareView(1, 2, true);
DiplShareView(2, 1, true);

if (!Q_AlliesFirstBlood.IsEmpty())
	Q_AlliesFirstBlood.SetPlayer(1);
for (i = 1; i < 7; i += 1) {
	SpawnGroup("Q_VillageAllies" + i).SetCommand("attack", AreaCenter("A_Village" + i));
	RunAIHelper("GuardVillage" + i, "guard area", "Q_VillageAllies" + i, "A_Village" + i);
}