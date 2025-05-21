//void, Obj me, point pt

Hero  this;
point dest;
int   formed,i;

this = me.AsHero();

dest = GetVec(.posRH, pt, 16);

for (i = 0; i < .army.count; i += 1)
	.army[i].SetCommand("stand_position");

.SetCommand("stand_position");
