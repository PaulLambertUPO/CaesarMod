//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
ObjList ol;
Obj o;
int i;

this = objs[0].AsBuilding();
set = .settlement;

ol = set.ObjectsAround("Military");
ol.AddList(set.ObjectsAround("BaseMage"));

for (i = ol.count - 1; i >= 0; i -= 1) {
	o = ol[i];
	if (o.IsAlive)
		if (o.stamina < o.maxstamina)
			if (!.IsEnemy(o)) {
				bool unaffordable = false;

				if (cmdcost_gold > set.gold)
					unaffordable = true;
				else if (cmdcost_food > set.food)
					unaffordable = true;
				else if (cmdcost_pop > 0)
					if (set.population - cmdcost_pop < GetConst("MinPopulation"))
						unaffordable = true;

				reasonText = rollover(this, unaffordable);

				return true;
			}
}

reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("There are no allies to revitalize around the settlement");

return false;