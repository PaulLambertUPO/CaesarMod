// void, Obj me, Obj u

Unit this;
Obj target;

this = me.AsUnit();

while (1) {
	if (!.IsValidTarget(u)) break;
	if (!.InRange(u)) break;
	.Attack(u);
}

