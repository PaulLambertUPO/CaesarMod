//void, Obj this, point pt

Obj eye;

eye = Place("WatchEyeNoReveal", pt, .player);
eye.SetSight(1000);
eye.SetCommand("spy");