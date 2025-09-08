//void, Obj this, point pt

Settlement set;
Obj new_expedition_watch_eye, old_expedition_watch_eye;

set = .AsBuilding().settlement;

EnvWriteString(.AsBuilding(), "researching", "yes");
EnvWriteString(set, "Expedition", "researching");

.Progress();

new_expedition_watch_eye = Place("WatchEye", pt, .player);
new_expedition_watch_eye.SetSight(1000);
new_expedition_watch_eye.SetCommand("infinite_spy");

old_expedition_watch_eye = EnvReadObj(set, "ExpeditionWatchEye");
if (old_expedition_watch_eye.IsValid)
	old_expedition_watch_eye.Erase();

EnvWriteObj(set, "ExpeditionWatchEye", new_expedition_watch_eye);