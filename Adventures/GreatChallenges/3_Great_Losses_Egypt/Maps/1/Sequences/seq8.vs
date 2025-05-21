Obj o1, o2;

while (1) {
	if (!GoodHero.IsEmpty())
		WaitConvRequest(GoodHero, NO_mercenary, 1000, o1, o2);
	else
		WaitConvRequest(ClassPlayerObjs(cUnit, 1), NO_mercenary, 1000, o1, o2);
	if (o2.IsValid)
		break;
}

RunConv("C_Conv4");