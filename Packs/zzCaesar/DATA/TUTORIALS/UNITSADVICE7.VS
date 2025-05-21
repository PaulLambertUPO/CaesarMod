//void, int playerid

//this script shows a hint about peasants and their production

Sleep(5000);

if (WaitQueryCountBetween(ClassPlayerObjs(cPeasant, playerid), 1, 1000, 300000))
	ShowHint(
		Translate("Peasants"),
		Translate("Peasants are civilian units that cannot fight but are essential because they are responsible for the production of the resources in a settlement and they are needed to equip military units (mercenaries excluded). The higher the population of a settlement is, the higher the amount of resources it will produce over time. Note that peasants are defenseless and slow, so you should protect them."),
		ClassPlayerObjs(cPeasant, playerid).GetObjList()[0]
	);
else {
	Obj obj;
	ShowHint(
		Translate("Peasant production"),
		Translate("Peasants can be produced either automatically over time (unless the population is below 10) or manually with specific commands in taverns and villages. Peasants are civilian units that cannot fight but are essential because they are responsible for the production of the resources in a settlement and they are needed to equip military units (mercenaries excluded). The higher the population of a settlement is, the higher the amount of resources it will produce over time. Note that peasants are defenseless and slow, so you should protect them."),
		obj
	);
}