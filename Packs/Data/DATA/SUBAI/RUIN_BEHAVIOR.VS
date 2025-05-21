//void, Obj This

bool bRespawn;
str items, item; 
Building this;
int count, idx, minlevel, timetorest;
Item item_obj;
Hero hero;

this = This.AsBuilding;
minlevel = .minlevel;
EnvWriteInt(this, "minlevel", minlevel);
bRespawn = true;
timetorest = 0;

Sleep(rand(1000) + 500);

while(1)
{
	if(bRespawn)
	{
		// first count 'em
		count = 0;
		items = .itemtypes;
		while(items != "")
		{
			item = ParseStr(items, items);
			count += 1;
		}
		idx = rand(count);

		items = .itemtypes;
		while(idx > 0)
		{
			item = ParseStr(items, items);
			idx -= 1;
		}
		.AddItem(item);
		item_obj = .FindItem(item);
		bRespawn = false;
	}
	if(.settlement.UnitsCount > 0)
	{
		hero = .settlement.Units[0].AsHero();
		if (hero.IsAlive)
		{
			hero.Deselect();
			Sleep(10000);
			if (hero.IsAlive)
			if (hero.InHolder)
			{
				bool bCanGetItem = false;
				//if (10 * hero.health >= 9 * hero.maxhealth)
				if (hero.level >= minlevel)
				if (hero.item_count < hero.max_items)
					bCanGetItem = true;
				if (hero.health > hero.maxhealth * 20 / 100)
					hero.Damage(hero.health - hero.maxhealth * 20 / 100);
				if(hero.CmdCount == 1)
					hero.AddCommand(true, "move", .GetExitPoint(hero, .pos)+Point(10, 50));
				hero.KillCommand();
				if (timetorest == 0 && bCanGetItem)
				{
					minlevel += .levelperitem;
					EnvWriteInt(this, "minlevel", minlevel);
					Sleep(250);
					.GiveItem(item_obj, hero);
					timetorest = 600;
				} else
				{
					continue;
				}
			}
		}
	}
	if(timetorest == 1 && !bRespawn)
	{
		bRespawn = true;
	}		
	if(timetorest > 0)
		timetorest -= 1;

	Sleep(1000);
}
