// void, Obj me, point pt

Unit this;
Obj u;

this = me.AsUnit();

if(.IsValid() == false)
	return;

if(.IsHeirOf("Animal") == true)
	.SetCommand("move", pt);
	
if(IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

	
while (1) 
{
	//pr("advance_aggressive: searching for new enemy");
	u = .BestTargetInSquadSight();
	if (u.IsAlive())
	if (.IsValidTarget(u))
	{
		Sleep(rand(80) + 20); // prevent cycling advance_aggressive->engage->advance_aggressive->...
		.AddCommand(true, "advance_aggressive", pt);
		.AddCommand(true, "engage");
		if(.HasSpecial(26) ) {
			.SetVisible(true);
		}
		return;
	} 
	
	//pr("advance_aggressive: no target in sight - returning to source point!");
	if (.Goto(pt, 0, 2000, true, 0)) return;
	
}
