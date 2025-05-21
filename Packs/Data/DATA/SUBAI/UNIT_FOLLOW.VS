// void, Obj This, Obj other

Unit this;
this = This.AsUnit();
if(.IsValid() == true && IsAIPlayer(.player) == true) // leave parry mode at new command
	.SetParryMode(false);

//.pr("The script should be modified to check if the unit is still visible");
while (other.IsAlive())
  {
	 if(.Goto(other,.sight-50,5000, true, 15000))
		Sleep(1500);
  }