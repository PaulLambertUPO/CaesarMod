// void, Obj This 

Building this;
int k;
this = This.AsBuilding();

.Progress();

k = EnvReadInt(.player, "MaxElephants");
EnvWriteInt(.player, "MaxElephants", k + 1);

