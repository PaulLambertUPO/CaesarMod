//void, Obj owner

Unit this;

this = owner.AsUnit();

if (.IsValid) {
	.Heal(.maxhealth);
	.HealStamina(.maxstamina);
	if (!.InHolder) {
		CreateFeedback("Heal", this);
		CreateFeedback("StaminaBoost", this);
	}
	ItemUsed(1);
}