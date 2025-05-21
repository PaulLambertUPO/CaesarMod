// void, Obj This 

Building this;
int k;
this = This.AsBuilding();

.Progress();

k = EnvReadInt(.player, "MaxHuntresses");
EnvWriteInt(.player, "MaxHuntresses", k + 10);
EnvWriteString(.player, "Increase Javelin production", "researched");
