// void, Obj me, Obj tgt

Unit this;
Obj u;
str class;
bool melee;

this = me.AsUnit();

class = tgt.class;

melee = !.IsRanged;

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

u = .BestTargetInSquadSightExclusive(class);

while (.IsValidTarget(u)) 
{
	while(!.GotoAttack(u, 1500, true, 15000)) 
	{
		u = .BestTargetInSquadSightExclusive(class);
		if(!.IsValidTarget(u)) break;
	}

	if (.IsValidTarget(u)) {
		if (u.AsCatapult().IsValid) {
			while (.Attack(u))
				if (melee)
					if (.HasSpecial(trample))
						u.Damage(.damage);
		}
		else while (.Attack(u))
			;
	}

	u = .BestTargetInSquadSightExclusive(class);
}
