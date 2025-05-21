//void, Obj owner, Obj victim

if (owner.IsValid) {
	if (owner.health < owner.maxhealth)
		owner.Heal(owner.maxhealth);
	owner.RemoveItem("God's Gift");
}