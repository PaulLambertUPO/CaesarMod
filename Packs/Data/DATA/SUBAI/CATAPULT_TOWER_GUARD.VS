// void, Obj me

Tower this;
Unit u;
Obj target;
bool bAttacked;

this = me.AsTower();
if (!.IsValid) return;

while (true) {
	target = .GetUITarget();
	if (target.IsAlive() && .IsValidTarget(target)) {
		if (.CanAttack(target)) {
			bAttacked = false;
			while (.Attack(target)) {
				bAttacked = true;
				Sleep(100);
				target = .GetUITarget();
				if (!target.IsValid)
					break;
				if (!target.IsAlive)
					break;
				if (!.IsValidTarget(target))
					break;
				if (!.CanAttack(target))
					break;
			}
			Sleep(500);
			if (bAttacked)
				continue;
		}
	}
	Sleep(500);
}