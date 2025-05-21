int event, event_interval, timer;
bool notify_events = true;

event_interval = 1440000 - GetDifficulty() * 120000;
timer = event_interval;

Sleep(1000);

while (1) {
	if (selu.IsValid())
		if (selu.name == "Senator") {
			RunConv("NeedHelp");
			ClearSelection(1);
		}
	Sleep(50);
	if (notify_events) {
		timer -= 50;
		if (timer <= 0) {
			event += 1;
			timer = event_interval;
			if (event == 1)
				EnvWriteInt("/Ships", 1);
			else if (event == 2)
				EnvWriteInt("/Caves", 1);
			else if (event == 3)
				EnvWriteInt("/GlobalSpells", 1);
			else if (event == 4)
				EnvWriteInt("/ImportantTown", 1);
			else
				EnvWriteInt("/CalgacusArmy", 1);
			RunConv("InfoConv");
			ClearSelection(1);
		}
		notify_events = EnvReadInt("/CalgacusArmy") != 1;
	}
}