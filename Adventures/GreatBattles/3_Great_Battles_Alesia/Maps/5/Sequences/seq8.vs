IntArray fortifications_times;
int i, max_time_to_retake, min_time_to_retake;

max_time_to_retake = 360 - GetDifficulty() * 60;
min_time_to_retake = max_time_to_retake;

WaitEnvIntBetween("/En_IntroEnds", 1, 1, -1);

for (i = 1; i <= 8; i += 1)
	fortifications_times[i] = max_time_to_retake;

while (min_time_to_retake > 0) {
	min_time_to_retake = max_time_to_retake;
	for (i = 1; i <= 8; i += 1)
		if (GetNamedObj("NO_FortificationPoint" + i).obj.player != 1) {
			fortifications_times[i] -= 2;
			min_time_to_retake = MIN(min_time_to_retake, fortifications_times[i]);
		}
		else
			fortifications_times[i] = max_time_to_retake;
	if (min_time_to_retake < max_time_to_retake)
		ShowAnnouncement("TimeToRetake", Translatef("Retake the positions in %s1 seconds", min_time_to_retake));
	else
		HideAnnouncement("TimeToRetake");
	Sleep(2000);
}

ClearNotes();
EndGame(1, true, Translate("The siege is broken."));