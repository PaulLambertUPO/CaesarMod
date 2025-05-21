// void, Obj this, point pt

Obj WatchEye;
WatchEye = Place("WatchEye", pt, .player);
WatchEye.SetSight(1000);
WatchEye.SetCommand("spy");
