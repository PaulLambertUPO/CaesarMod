// void, Obj me, point pt

Unit this;
Obj u;

this = me.AsUnit();

if (!.IsValid)
	return;
	
if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);
 
while (1) 
{
	//pr("advance: searching for new enemy");
	u = .BestTargetInSquadSight();
	if (u.IsAlive())
	if (u.IsMilitary() || u.IsHeirOf("BaseMage"))
	if (.IsMilitary())
	if (u.attack > 0)	
	{
		 Sleep(10);
		.AddCommand(true, "guardadvance", pt);
		.AddCommand(true, "guardengage");
		return;
	}
	
	//pr("advance: no target in sight - returning to source point!");
	if (.Goto(pt, 0, 2000, true, 0)) return;	
}
