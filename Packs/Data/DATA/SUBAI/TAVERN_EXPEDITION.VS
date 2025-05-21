// void, Obj this, point pt
Obj WatchEye, WatchEyePrev;
Settlement sett;

sett = .AsBuilding.settlement;

EnvWriteString(this.AsBuilding, "researching", "yes");
EnvWriteString(sett, "Expedition", "researching");

.Progress();

WatchEye = Place("WatchEye", pt, .player);
WatchEye.SetSight(1000);
WatchEye.SetCommand("infinite_spy");

// remove the previous eye
WatchEyePrev = EnvReadObj(sett, "WatchEye");
if (WatchEyePrev.IsValid)
	WatchEyePrev.Damage(WatchEyePrev.maxhealth);

EnvWriteObj(sett, "WatchEye", WatchEye);
