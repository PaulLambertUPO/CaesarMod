// void, Obj This 

Building this;
int k;
this = This.AsBuilding();

.Progress();

k = EnvReadInt(.player, "MaxMacemen");
EnvWriteInt(.player, "MaxMacemen", k + 10);
EnvWriteString(.player, "Increase Mace production", "researched");
