// void, Obj This, Obj other

Unit this;
this = This.AsUnit();

if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

//.pr("The script should be modified to check if the unit is still visible");

if (other.IsAlive())
	while (!.Goto(other,other.sight/3,5000,true,-1));
other.SetCommand("transport_request");