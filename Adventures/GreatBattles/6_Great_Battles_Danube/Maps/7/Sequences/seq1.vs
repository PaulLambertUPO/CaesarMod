int army_status;

RunConv("C_Conv0");
GiveNote("Defend Aquileia");
GiveNote("Marcus Aurelius");

AttackArea(Q_IntroGermansRight1, "A_RightPos1");
AttackArea(Q_IntroGermansRight2, "A_RightPos1");
AttackArea(Q_IntroGermansMid1, "A_MiddlePos1");
AttackArea(Q_IntroGermansMid2, "A_MiddlePos1");
AttackArea(Q_IntroGermansLeft1, "A_LeftPos1");
AttackArea(Q_IntroGermansLeft2, "A_LeftPos1");
AttackArea(Q_IntroGroup, "A_IntroPos");
Sleep(30000);
AttackArea(Q_IntroGermansRight1, "A_RightPos2");
AttackArea(Q_IntroGermansRight2, "A_RightPos2");
AttackArea(Q_IntroGermansMid1, "A_MiddlePos2");
AttackArea(Q_IntroGermansMid2, "A_MiddlePos2");
AttackArea(Q_IntroGermansLeft1, "A_LeftPos2");
AttackArea(Q_IntroGermansLeft2, "A_LeftPos2");
AttackArea(Q_IntroGroup, "A_LeftPos2");
Q_MiddleDef1.SetCommand("idle");
Q_MiddleDef2.SetCommand("idle");
Q_LeftDef1.SetCommand("idle");
Q_LeftDef2.SetCommand("idle");
Sleep(20000);

RunConv("C_Conv1");
Sleep(40000);

if (!Q_IntroGermansRight1.IsEmpty())
	AttackArea(Q_IntroGermansRight1, "A_RightPos3");
if (!Q_IntroGermansRight2.IsEmpty())
	AttackArea(Q_IntroGermansRight2, "A_RightPos3");
if (!Q_IntroGermansMid1.IsEmpty())
	AttackArea(Q_IntroGermansMid1, "A_MiddlePos3");
if (!Q_IntroGermansMid2.IsEmpty())
	AttackArea(Q_IntroGermansMid2, "A_MiddlePos3");
if (!Q_IntroGermansLeft1.IsEmpty())
	AttackArea(Q_IntroGermansLeft1, "A_LeftPos3");
if (!Q_IntroGermansLeft2.IsEmpty())
	AttackArea(Q_IntroGermansLeft2, "A_LeftPos3");
if (!Q_IntroGroup.IsEmpty())
	AttackArea(Q_IntroGroup, "A_LeftPos3");

Sleep(120000);
if (!Q_IntroGermansRight2.IsEmpty())
	Q_IntroGermansRight2.SetCommand("attack", NO_RightPos.obj.pos);
if (!Q_IntroGermansMid2.IsEmpty())
	Q_IntroGermansMid2.SetCommand("attack", NO_MiddlePos.obj.pos);
if (!Q_IntroGermansLeft2.IsEmpty())
	Q_IntroGermansLeft2.SetCommand("attack", NO_LeftPos.obj.pos);
if (!Q_IntroGermansRight2.IsEmpty()) {
	Q_IntroGermansRight2.SetCommand("attack", NO_RightPos);
	EnvWriteInt("/En_ArchersAlone", 1);
}
if (!Q_IntroGermansMid2.IsEmpty()) {
	Q_IntroGermansMid2.SetCommand("attack", NO_MiddlePos);
	EnvWriteInt("/En_ArchersAlone", 1);
}
if (!Q_IntroGermansLeft2.IsEmpty()) {
	Q_IntroGermansLeft2.SetCommand("attack", NO_LeftPos);
	EnvWriteInt("/En_ArchersAlone", 1);
}
while (army_status == 0) {
	Sleep(1000);
	if (WaitHealthBetween(Q_RightPos, 0, 10, 2000))
		army_status = 1;
	else if (WaitHealthBetween(Q_MiddlePos, 0, 10, 2000))
		army_status = 1;
	else if (WaitHealthBetween(Q_LeftPos, 0, 10, 2000))
		army_status = 1;
	if (Q_IntroGermansRight2.IsEmpty())
		if (Q_IntroGermansMid2.IsEmpty())
			if (Q_IntroGermansLeft2.IsEmpty())
				army_status = 2;
}
if (army_status == 1)
	RunAIHelper("AttackingRomanTown", "guard area", "Q_IntroGermans", "A_Village7");
else {
	if (!Q_IntroGermansRight1.IsEmpty()) {
		Q_IntroGermansRight1.AddToGroup("Q_PreviousRight");
		AttackArea(Q_IntroGermansRight1, "A_Ruins");
		EnvWriteInt("/En_SendChasers", 1);
	}
	if (!Q_IntroGermansMid1.IsEmpty()) {
		Q_IntroGermansMid1.AddToGroup("Q_PreviousMain");
		AttackArea(Q_IntroGermansMid1, "A_GermanCamp");
		EnvWriteInt("/En_SendChasers", 1 );
	}
	if (!Q_IntroGermansLeft1.IsEmpty()) {
		Q_IntroGermansLeft1.AddToGroup("Q_PreviousMain");
		AttackArea(Q_IntroGermansLeft1, "A_GermanCamp");
		EnvWriteInt("/En_SendChasers", 1);
	}
}