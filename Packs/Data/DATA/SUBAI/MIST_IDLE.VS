//void, Obj This

int damage;

damage = GetConst("MistDamage");

This.PlayAnim(1, This.pos);

while (This.stamina > 0) {
	This.PlayAnim(2, This.pos);
	This.MistAction(damage);
}