ObjList ol;
int i, remaining_waves;

WaitEnvIntBetween("/En_FinalWave", 1, 1, -1);

RunConv("Retreat");
RemoveNote("Protect the chieftains.");
GiveNote("Final wave.");

SetFog(false);

Sleep(500);
for (i = 1; i <= 8; i += 1)
	if (!Group("G_CorridorDefenders" + i).IsEmpty())
		Group("G_CorridorDefenders" + i).RemoveFromGroup("G_CorridorDefenders" + i);
Sleep(500);
if (!IsAIHelperRunning("LastStand"))
	RunAIHelper("LastStand", "guard area", "G_CorridorDefenders", "A_GergoviaEntrance");

Sleep(2500);
remaining_waves = MAX(0, EnvReadInt("/En_MaxWaves") - EnvReadInt("/En_CurrentWave"));
for (i = 1; i < remaining_waves; i += 1)
	SpawnGroup("R_Invaders" + (1 + i - i / 8 * 8));
SpawnGroup("R_Invaders");
R_FinalArmy.SetCommand("attach", NO_FinalRomanHero);
NO_FinalRomanHero.obj.AsHero().SetAutocast(true);
Sleep(500);

AttackArea(R_Invaders, "A_FinalWave");
for (i = 0; i < 10 && !R_Invaders.IsEmpty(); i += 1)
	Sleep(18000);
AttackArea(R_Invaders, "A_GergoviaEntrance");
for (i = 0; i < 10 && !R_Invaders.IsEmpty(); i += 1)
	Sleep(3000);

while (!R_Invaders.IsEmpty()) {
	AttackArea(Subtract(R_Invaders, Group("R_Siegers")), "A_GergoviaEntrance");
	ClassPlayerAreaObjs(cMilitary, 4, "A_FinalSiege").AddToGroup("R_Siegers");
	if (!IsAIHelperRunning("FinalSiege"))
		RunAIHelper("FinalSiege", "siege", "R_Siegers", "S_Gergovia");
	if (!G_CorridorDefenders.IsEmpty())
		if (!IsAIHelperRunning("LastStand"))
			RunAIHelper("LastStand", "guard area", "G_CorridorDefenders", "A_GergoviaEntrance");
	Sleep(10000);
}

EnvWriteInt("/En_End", 1);