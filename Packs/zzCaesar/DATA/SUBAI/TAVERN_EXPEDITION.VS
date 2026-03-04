//void, Obj This, point pt

Building this;
Settlement set;

this = This.AsBuilding();
set = .settlement;

EnvWriteString(this, "researching", "yes");
EnvWriteString(set, "Expedition", "researching");

.Progress();

{
	Obj expedition_watch_eye;

	expedition_watch_eye = EnvReadObj(set, "ExpeditionWatchEye");
	if (expedition_watch_eye.IsValid)
		expedition_watch_eye.Erase();

	expedition_watch_eye = Place("WatchEyeBig", pt, .player);
	expedition_watch_eye.SetCommand("infinite_spy");

	EnvWriteObj(set, "ExpeditionWatchEye", expedition_watch_eye);
}