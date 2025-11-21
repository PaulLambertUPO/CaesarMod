// void, Obj me

Unit this, u;
bool melee;

this = me.AsUnit();
melee = !.IsRanged;

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

while (!.Stop(1000));

u = .BestTargetForPos();
while( 1 )
{
	while(u.IsAlive())
	{
		if (u.AsCatapult().IsValid) {
			while (.Attack(u))
				if (melee)
					if (.HasSpecial(trample))
						u.Damage(.damage);
		}
		else
			while(.Attack(u))
				;
		u = .BestTargetForPos();
	}
	.Idle(2000);
	u = .BestTargetForPos();
}
