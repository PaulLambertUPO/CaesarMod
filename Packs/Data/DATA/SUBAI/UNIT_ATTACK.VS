// void, Obj me, Obj u

Unit this;
ObjList enemies;
bool melee;

this = me.AsUnit();

if (!.IsValid()) return;
if (!u.IsValid()) return;
if( (u.IsEnemy(this) == false && .player() != u.player()) || (u.IsHeirOf("Catapult") && u.IsEnemy(this) == false) || (u.IsHeirOf("RamUnit") && u.IsEnemy(this) == false) )
{
	return;
}

melee = !.IsRanged;

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);
 
if(.HasSpecial(26) ) {
	.SetVisible(true);
}

//.pr("unit::attack: attacking particular enemy");

if( u.AsBuilding.IsValid ) {
	Sleep(rand(400) + 200);
	if (!u.IsValid()) return; // buildings also can die (catapults)
}
if(.IsEnemy(u) || u.AsBuilding.IsValid)
{
	while(u.IsAlive() && .IsValidTarget(u))
	{
		if(!.IsEnemy(u) && !u.AsBuilding.IsValid)
			return;
		//.pr("unit::attack: going to enemy");
		if(.GotoAttack(u, 5000, true, 2500))
		{
			//.pr("unit::attack: fighting");
			if (u.AsCatapult().IsValid) {
				while (.Attack(u))
					if (melee)
						if (.HasSpecial(trample))
							u.Damage(.damage);
			}
			while(.Attack(u))
				;
		}
	} 
}
.AddCommand(true, "engage");