// void, Obj This, Obj target

Unit this;
Unit tgt;
bool bSleep = true;
int amount, stamina_cost;

this = This.AsUnit;
tgt = target.AsUnit;

stamina_cost = GetCmdStaminaCost("heal");

if (.IsAlive)
if (.HasSpecial(healing))
if (tgt != this)
if (tgt.IsAlive)
if (!target.AsShip.IsValid)
while (1)
{
	if (!.IsAlive)     break;
	if (!tgt.IsAlive)  break;
	if (tgt.health >= tgt.maxhealth) break;
	if (.IsEnemy(tgt)) break;
	if (tgt.InHolder)  break;
	if (!.CanSee(tgt)) break;
	bSleep = false;

	if (!.InRange(tgt)) {
		.GotoAttack(tgt, 2000, false, 2500);
		continue;
	}
	if (.stamina < stamina_cost) {
		Sleep(200);
		continue;
	}
	 .SetLastAttackTime();
	if (!.IsVisible)
		.SetVisible(true);
	.StartAnim(17, tgt.pos);
	Sleep(.TimeToActionMoment);

	if (tgt.IsAlive)
	if (tgt.health < tgt.maxhealth)
	if (!.IsEnemy(tgt))
	if (!tgt.InHolder)
	if (.CanSee(tgt))
	if (.stamina >= stamina_cost)
	{
		.SetVisible(true); .SetLastAttackTime();
		.SetStamina(.stamina - stamina_cost);
		amount = GetConst("HealAmount") + .level;
		tgt.Heal(amount);
		CreateFeedback("Heal", tgt);
	}
	Sleep(.TimeToAnimFinish);
}

if (bSleep)
	Sleep(17); // otherwise can cycle: Advance->Heal->Advance->Heal...
