//void, Obj me, Obj target

Catapult this;

this = me.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (.CmdCount <= 1)
				.SetTarget(target);