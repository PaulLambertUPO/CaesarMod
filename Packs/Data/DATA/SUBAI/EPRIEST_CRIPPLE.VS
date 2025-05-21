// void, Obj This, Obj target

Druid this;
Unit tgt;
bool bSleep = true;
int cripple_stamina_cost;

this = This.AsDruid();
tgt = target.AsUnit();
if (tgt.IsHeirOf("RamUnit"))
	return;

cripple_stamina_cost = GetCmdStaminaCost("cripple");

while (1)
{
	if (!.IsAlive)      break;
	if (!tgt.IsAlive()) break;
	if (!.IsEnemy(tgt)) break;
	if (tgt.InHolder)   break;
	if (!.CanSee(tgt))  break;
	if (tgt.stamina <= 0) break;

	bSleep = false;
	if (!.InRange(tgt)) {
		.GotoAttack(tgt, 2000, false, 2500);
		continue;
	}
	if (.stamina < cripple_stamina_cost) {
		Sleep(200);
		continue;
	}
	.SetLastAttackTime();
	if (!.IsVisible)
		.SetVisible(true);
	.StartAnim(17, tgt.pos);
	Sleep(.TimeToActionMoment());

	if (tgt.IsAlive())
	if (.IsEnemy(tgt))
	if (!tgt.InHolder)
	if (.CanSee(tgt))
	if (.stamina >= cripple_stamina_cost)
	{
		.SetVisible(true); .SetLastAttackTime();
		.SetStamina(.stamina - cripple_stamina_cost);
		tgt.SetStamina(0);
		CreateFeedback("StaminaLoss", tgt);
	}
	Sleep(.TimeToAnimFinish());
}

if (bSleep)
	Sleep(17); // otherwise can cycle: Advance->Cripple->Advance->Cripple...
