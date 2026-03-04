//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (!.InHolder)
			.Stop(2000);

		while (.CmdCount == 1)//avoid blocking pending commands forever
			Sleep(1000);
	}