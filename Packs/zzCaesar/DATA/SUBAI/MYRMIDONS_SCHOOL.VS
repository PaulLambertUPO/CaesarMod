//void, Obj This

Building this;
int player;

this = This.AsBuilding();

.Progress();

player = .player;

EnvWriteString(this, "researching", "no");

EnvWriteInt(player, "MaxMyrmidons", MIN(GetConst("MaxMyrmidonsValue"), EnvReadInt(player, "MaxMyrmidons") + 10));

PlaySound(player, "Data/Sounds Entities/UpgradeComplete.xml");