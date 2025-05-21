// void, Obj me, Obj tgt

Unit this;
Obj u;
str class;
class = tgt.class;

this = me.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

u = .BestTargetInSquadSight(class);

while (.IsValidTarget(u)) 
{
	while(!.GotoAttack(u, 1500, true, 15000)) 
	{
		u = .BestTargetInSquadSight(class);
		if(!.IsValidTarget(u)) break;
	}

	if (.IsValidTarget(u))
		while (.Attack(u));

	u = .BestTargetInSquadSight(class);
}
