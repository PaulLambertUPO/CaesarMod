//void, Obj me

Catapult this;

this = me.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		.ClearTowerTarget();//stop the fake tower (for the Roman tower) without forgetting the target (it will remain in m_hTarget)