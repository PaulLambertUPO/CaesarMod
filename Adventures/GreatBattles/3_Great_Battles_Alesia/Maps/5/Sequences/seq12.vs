Conversation conv;
Unit messenger;
int i, dist, nearest_dist = 1000000, mes_chosen = 1;

WaitEnvIntBetween("/En_IntroEnds", 1, 1, -1);

SpawnGroup("Q_Messengers");
for (i = 1; i <= 8; i += 1) {
	dist = Dist(GetNamedObj("NO_Messenger" + i).obj.posRH, NO_Caesar.obj.posRH);
	if (dist < nearest_dist) {
		nearest_dist = dist;
		mes_chosen = i;
	}
}
for (i = 1; i <= 8; i += 1)
	if (mes_chosen == i) {
		messenger = GetNamedObj("NO_Messenger" + i).obj.AsUnit();
		messenger.SetCommand("move", NO_Caesar.obj.posRH);
	}
	else
		GetNamedObj("NO_Messenger" + i).Erase();

while (1) {
	Sleep(3000);
	if (messenger.DistTo(NO_Caesar.obj.posRH) < 700) {
		conv.Init("Escapers");
		conv.SetActor("NO_Caesar", NO_Caesar.obj.AsUnit());
		conv.SetActor("NO_Messenger", messenger);
		conv.Run();
		GiveNote("Gaul reinforcements");
		messenger.SetMessengerStatus(false);
		messenger.SetPlayer(1);
		break;
	}
	else
		messenger.SetCommand("move", NO_Caesar.obj.posRH);
}

WaitEnvIntBetween("/En_AllWavesGone", 1, 1, -1);

if (Q_Messengers.IsEmpty()) {
	SpawnGroup("Q_Messengers");
	nearest_dist = 1000000;
	mes_chosen = 1;
	for (i = 1; i <= 8; i += 1) {
		dist = Dist(GetNamedObj("NO_Messenger" + i).obj.posRH, NO_Caesar.obj.posRH);
		if (dist < nearest_dist) {
			nearest_dist = dist;
			mes_chosen = i;
		}
	}
	for (i = 1; i <= 8; i += 1)
		if (mes_chosen == i) {
			messenger = GetNamedObj("NO_Messenger" + i).obj.AsUnit();
			messenger.SetCommand("move", NO_Caesar.obj.posRH);
		}
		else
			GetNamedObj("NO_Messenger" + i).Erase();
}
else {
	messenger.SetMessengerStatus(true);
	messenger.DetachFrom(messenger.hero);
	messenger.SetPlayer(7);
}

while (1) {
	Sleep(3000);
	if (messenger.DistTo(NO_Caesar.obj.posRH) < 700) {
		conv.Init("WavesGone");
		conv.SetActor("NO_Caesar", NO_Caesar.obj.AsUnit());
		conv.SetActor("NO_Messenger", messenger);
		conv.Run();
		RemoveNote("Gaul reinforcements");
		GiveNote("CaptureAlesia2");
		messenger.SetMessengerStatus(false);
		messenger.SetPlayer(1);
		break;
	}
	else
		messenger.SetCommand("move", NO_Caesar.obj.posRH);
}