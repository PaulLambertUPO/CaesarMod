//void, Obj this, Settlement sett

if (.AsUnit().IsValid)
	if (sett.IsValid)
		if (sett.max_gold > 0) {
			Item item;
			int i;

			for (i = .items_count; i >= 1; i -= 1) {
				item = .GetItem(i);
				if (item.IsValid)
					if (item.name == "Spoils of War") {
						sett.SetGold(sett.gold + 100);
						sett.GoldConverted(100);
						.RemoveItem(i);
					}
					else if (item.name == "Gold") {
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