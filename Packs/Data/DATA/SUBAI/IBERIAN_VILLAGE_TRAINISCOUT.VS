// void, Obj This

Building this;
Unit scout;
point ptDest, ptExit;
int lRadius = 30; //Raggio cavalieri.
int cmd_pop=5;
this = This.AsBuilding();

Sleep(100);
if(EnvReadInt(.settlement(), "EEE_IVillageNumberHorses") == 0)
{
	.settlement().SetPopulation(.settlement().population() + cmd_pop);
	return;
}
if(.IsValid() == false)
{
	return;
}
if(.race() != Iberia) //Only iberian villages can train IScout.
{
	return;
}

Sleep(100);
//Determina il punto di uscita e il punto appena fuori dal villaggio in cui lo scout dovra andare dopo essere uscito.
ptExit = .GetExitPoint(.settlement().GetCentralBuilding().pos(), false);
ptDest.Set(1, 1);
ptDest.SetLen(rand(lRadius - .settlement().GetCentralBuilding().radius()) + .settlement().GetCentralBuilding().radius());
ptDest.Rot(rand(360));
ptDest = ptDest + .settlement().GetCentralBuilding().pos();

scout = Place("IScout", ptExit, .player());
EnvWriteInt(.settlement(), "EEE_IVillageNumberHorses", EnvReadInt(.settlement(), "EEE_IVillageNumberHorses") - 1);
Sleep(200);

if(scout.IsValid() == false)
{
	//WTF?!?
	return;
}
if(scout.IsAlive() == true)
{
	//Se è stabilita una rotta, l'esploratore si recherà nell'insediamento.
	if (.settlement().supplied().IsValid() == true)
	{
		if( (.settlement().supplied().IsTTent() == false) && (scout.IsEnemy(.settlement().supplied().GetCentralBuilding()) == false) )
		{
			scout.SetCommand("enter", .settlement().supplied().GetCentralBuilding());
			Sleep(250);
			return;
		}
	}

	scout.SetCommand("move", ptDest);
	
}