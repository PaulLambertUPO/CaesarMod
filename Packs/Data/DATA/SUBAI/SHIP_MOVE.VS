// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);

while (!.Goto(pt, 0, 50, true, 0));
