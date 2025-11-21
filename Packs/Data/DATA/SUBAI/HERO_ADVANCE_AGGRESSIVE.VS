// void, Obj This, point pt

Hero this;
Obj u;
point dpt;
bool bSquadTarget;
int i;

this = This.AsHero ();
//.pr("hero::advance_aggressive : move setup");
.FormSetupAndMoveTo (pt, 0, 0, true);
// Wait for army to exit
while(!.IsArmyOutside())
	.FormKeepMoving(500);
while(.HasPath())
{
	//.pr("Hero::advance_aggressive:Looking for enemys");
	if (.IsEnemyInSquadSight()) {
		bSquadTarget = false;
		u = .BestTargetInSquadSight();
		if (u.IsAlive())
			bSquadTarget = true;
		for (i = 0; !bSquadTarget && i < .army.count; i += 1) {
			u = .army[i].AsUnit.BestTargetInSquadSight();
			if (u.IsAlive())
				bSquadTarget = true;
		}		
		if (bSquadTarget) {
			.AddCommand(true, "advance_aggressive", pt);
			.AddCommand(true, "engage");
			return;
		}
	}
	//.pr("hero::advance_aggressive: No Enemy");
	//.pr("hero::advance_aggressive:moving");
	.FormKeepMoving (1500);
}	

dpt = .GetFinalPartyOrientation() - Point(1024, 1024);
if (dpt.x != 0 || dpt.y != 0)
	.Face(.pos + dpt);
