// void, Obj This 

Building this;
int k;
this = This.AsBuilding();

.Progress();

k = EnvReadInt(.player, "MaxTeutonRiders");
EnvWriteInt(.player, "MaxTeutonRiders", k + 10);
EnvWriteString(.player, "Increase Horseshoe production", "researched");
