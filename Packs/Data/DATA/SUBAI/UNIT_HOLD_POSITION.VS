// void, Obj me

Unit this, u;

this = me.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

while (!.Stop(1000));

u = .BestTargetForPos();
while( 1 )
{
	while(u.IsAlive())
	{
		while(.Attack(u));
		u = .BestTargetForPos();
	}
	.Idle(2000);
	u = .BestTargetForPos();
}
