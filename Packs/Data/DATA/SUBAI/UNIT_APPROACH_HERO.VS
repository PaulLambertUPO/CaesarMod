// void, Obj This, Obj other

Unit this;
int nApproachDistance;

nApproachDistance = GetConst("HeroApproachDistance");
this = This.AsUnit();

while (.hero.IsAlive()) {
	if(.Goto(.hero,nApproachDistance,5000,false,5000))
		break;
}
