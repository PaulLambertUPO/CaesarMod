// void, Obj This, Obj target

Druid this;
Unit tgt;
int revitalize_amount, revitalize_stamina_cost;

this = This.AsDruid;
if (!.IsAlive) return;
if (!.HasSpecial(revitalize)) return;

tgt = target.AsUnit;
if (tgt == this)
	return;
if (!tgt.IsAlive)
	return;
if (target.AsShip.IsValid)
	return;
if (target.AsDruid.IsValid)
	return;

revitalize_amount = GetConst("RevitalizeAmount");
revitalize_stamina_cost = GetCmdStaminaCost("revitalize");

while (1)
{
	if (!.IsAlive)     break;
	if (!tgt.IsAlive)  break;
	if (tgt.stamina >= tgt.maxstamina) break;
	if (.IsEnemy(tgt)) break;
	if (tgt.InHolder)  break;
	if (!.CanSee(tgt)) break;

	if (!.InRange(tgt)) {
		.GotoAttack(tgt, 2000, false, 2500);
		continue;
	}
	if (.stamina < revitalize_stamina_cost) {
		Sleep(213);
		continue;
	}
	if (!.IsVisible)
		.SetVisible(true);
	.StartAnim(17, tgt.pos);
	Sleep(.TimeToActionMoment);

	if (tgt.IsAlive)
	if (tgt.stamina < tgt.maxstamina)
	if (!.IsEnemy(tgt))
	if (!tgt.InHolder)
	if (.CanSee(tgt))
	if (.stamina >= revitalize_stamina_cost)
	{
		.SetVisible(true); .SetLastAttackTime();
		.SetStamina(.stamina - revitalize_stamina_cost);
		tgt.HealStamina(revitalize_amount);
		CreateFeedback("StaminaBoost", tgt);
	}
	Sleep(.TimeToAnimFinish);
}
