//void, Obj me

Unit this;

this = me.AsUnit();

.SetNoselectFlag(true);
.SetMinimapFlag(true);

Sleep(rand(10) + 1);

while (1)
	.PlayAnim(1, .pos);