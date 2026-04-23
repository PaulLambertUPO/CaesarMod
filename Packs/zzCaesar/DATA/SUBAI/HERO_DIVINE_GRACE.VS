//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Obj o;
int i, cost;

cost = cmdcost_stamina;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		if (o.health < o.maxhealth)
			if (o.stamina >= cost) {
				o.SetStamina(o.stamina - cost);
				o.Heal(100);
				CreateFeedback("Heal", o.AsUnit());
			}
}