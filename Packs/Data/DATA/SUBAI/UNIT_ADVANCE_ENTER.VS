// void, Obj This,Obj bld

Unit this,u;
point pt;
Building building;
bool error;

this = This.AsUnit();
building = bld.AsBuilding();

if (!building.IsValid() || this.IsEnemy(building) || building.settlement.max_units==0)
  return;

if (.AsHero.IsValid) {
	int k;
	ObjList ol;
	Unit u;
	ol = .AsHero.army();
	for (k = 0; k < ol.count; k += 1) {
		u = ol[k].AsUnit();
		if (u.IsAlive())
			u.SetCommand("advanceenter", bld);
	}
}

.SetEntering(true);
if (!building.settlement.Units().Contains(this))
  {
    pt = building.GetEnterPoint(this);
	while (1) {
		u = .BestTargetInSquadSight().AsUnit();
		if(u.IsAlive())
		if(u.attack > 0)	
		{
			//pr("Best target found");
			while (u.IsAlive() && .IsValidTarget(u)) {
				//pr("Going to target");
				if(.HasSpecial(26) ) {
					.SetVisible(true);
				}
				while(!.GotoAttack(u, 1500, true, 15000)) {
					u = .BestTargetInSquadSight().AsUnit();
					if(!u.IsAlive() || !.IsValidTarget(u)) break;
				}
				//pr("attacking target");
				if (u.IsAlive() && .IsValidTarget(u))
				{
					while (.Attack(u));
				}
				u = .BestTargetInSquadSight().AsUnit();
			}
			continue;
		} 

		//pr("entering");
		if (.GotoEnter(pt, 0, 2000, true, 2500)) break;
		
	}

    //.pr("unit::enter: entering");
    building.settlement.AddUnit(this);
  }

