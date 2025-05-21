// bool, Obj This, point pt

Hero this;
this = This.AsHero();

if (!.EnemiesInSight()) return false;
if (pt.Dist(.posRH) >= .sight/2) return false;
if (.command == "stand_position") return false;
return true;
