//void, Obj This

Settlement this, supplied;
ObjList macemen, hoplites, units_in, units_out;
Wagon wagon;
Unit u;
Building suppliedHall;
int refresh, food_sales, food_income, gold_income, required_gold, min_resource, i;
bool is_gold_outpost = false, is_selling_food, is_selling_gold;

this = This.AsBuilding().settlement;

refresh = GetConst("OutpostRefresh");
food_sales = GetConst("GOutpostFoodSales");
food_income = GetConst("GOutpostGoldReturn");
gold_income = GetConst("ROutpostGoldReturn");
required_gold = GetConst("ROutpostRequiredGold");
min_resource = GetConst("MinResQtyToTransport");

if (This.class == "ROutpost")
	is_gold_outpost = true;
else if (This.class == "EOutpost")
	is_gold_outpost = true;

while (.IsIndependent)
	Sleep(refresh);

while (1) {
	//resources production
	is_selling_food = EnvReadString(this, "GOutpostSellFood") == "yes";
	is_selling_gold = EnvReadString(this, "GOutpostSellGold") == "yes";
	if (is_selling_food)
		if (.food >= food_sales) {
			.SetFood(.food - food_sales);
			.SetGold(.gold + food_income);
			.GoldConverted(food_income);
		}
	if (is_selling_gold)
		if (.gold >= food_income) {
			.SetGold(.gold - food_income);
			.SetFood(.food + food_sales);
		}
	if (is_gold_outpost)
		if (.gold >= required_gold) {
			.SetGold(.gold + gold_income);
			.GoldConverted(gold_income);
		}

	//supplying routes
	if (.supplied == this)
		.StopSupply();

	supplied = .supplied;

	if (supplied.IsValid)
		if (DiplGetCeaseFire(.player, supplied.player)) {
			suppliedHall = supplied.GetCentralBuilding();

			if (!is_selling_gold)
				if (.gold >= min_resource) {
					int gold = 1000;
					if (is_gold_outpost)
						if (.gold >= required_gold)
							if (.gold - required_gold < gold)
								gold = .gold - required_gold;//0-999
					if (gold >= min_resource) {
						wagon = .CreateMuleGold(gold);
						wagon.SetCommand("unload", suppliedHall);
					}
				}
			if (!is_selling_food)
				if (.food >= min_resource) {
					wagon = .CreateMuleFood(MIN(1000, .food));
					wagon.SetCommand("unload", suppliedHall);
				}

			//converted units management
			macemen.Clear();
			hoplites.Clear();
			units_in = .Units;
			for (i = 0; i < units_in.count; i += 1) {
				u = units_in[i].AsUnit();
				if (u.IsValid)
					if (!u.GetCommanded())
						if (u.IsHeirOf("CMaceman"))
							macemen.Add(u);
						else if (u.IsHeirOf("HHoplite"))
							hoplites.Add(u);
			}
			if (suppliedHall.IsHeirOf("BaseTownhall")) {
				if (macemen.count >= 5)
					macemen.SetCommand("enter", suppliedHall);
				if (hoplites.count >= 5)
					hoplites.SetCommand("enter", suppliedHall);
			}
			else if (suppliedHall.IsHeirOf("Outpost")) {
				if (macemen.count >= 5)
					macemen.SetCommand("enter", suppliedHall);
				if (hoplites.count >= 5)
					hoplites.SetCommand("enter", suppliedHall);
			}

			//units out management
			units_in = .Units;
			if (units_in.count > 0) {
				point pt;

				units_out.Clear();
				for (i = 0; i < units_in.count; i += 1) {
					if (This.AsBuilding.IsEnemy(units_in[i]))
						units_out.Add(units_in[i]);
				}
				units_out.ClearDead();

				pt.Set(1, 0);
				pt.SetLen(This.AsBuilding().radius);
				pt.Rot(rand(360));
				pt = pt + This.AsBuilding().pos;
				units_out.SetCommand("advance", pt);
			}
		}

	Sleep(refresh);
}