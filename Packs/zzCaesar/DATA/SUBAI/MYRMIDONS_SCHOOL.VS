//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

EnvWriteString(this, "researching", "no");

EnvWriteInt(.player, "MaxMyrmidons", MIN(GetConst("MaxMyrmidonsValue"), EnvReadInt(.player, "MaxMyrmidons") + 10));

PlaySound(.player, "Data/Sounds Entities/UpgradeComplete.xml");