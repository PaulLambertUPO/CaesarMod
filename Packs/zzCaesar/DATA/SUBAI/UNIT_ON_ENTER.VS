//void, Obj this, Settlement sett

if (.IsValid)
	if (.AsUnit().IsValid)
		if (sett.IsValid)
			if (sett.max_gold > 0) {//exclude catapults, ruins, teleports and tents
				Item item;
				int i;

				i = .RemoveItemsOfType("Spoils of War");

				if (i > 0) {
					int gold;

					gold = GetConst("SpoilsOfWarGold");

					sett.SetGold(sett.gold + i * gold);
					sett.GoldConverted(i * gold);
				}

				for (i = 1; i <= .item_count; i += 1) {
					item = .GetItem(i);
					if (item.IsValid)
						if (item.name == "Gold") {
							sett.SetGold(sett.gold + item.use_count);
							sett.GoldConverted(item.use_count);
							item.SetUseCount(0);
						}
				}
				for (i = .item_count; i >= 1; i -= 1) {
					item = .GetItem(i);
					if (item.IsValid)
						if (item.name == "Gold") {
							sett.SetGold(sett.gold + item.use_count);
							sett.GoldConverted(item.use_count);
							item.SetUseCount(0);
						}
						else if (item.name == "Gold bag") {
							sett.SetGold(sett.gold + item.use_count);
							sett.GoldConverted(item.use_count);
							.RemoveItem(i);
						}
				}
			}