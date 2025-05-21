// void, Obj This 

Building this;
int k;
this = This.AsBuilding();

.Progress();

k = EnvReadInt(.player, "MaxAxemen");
EnvWriteInt(.player, "MaxAxemen", k + 10);
EnvWriteString(.player, "Increase Axe production", "researched");
