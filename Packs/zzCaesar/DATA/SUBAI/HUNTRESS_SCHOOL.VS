//void, Obj This

int player;

This.AsBuilding().Progress();

player = This.player;

EnvWriteInt(player, "MaxHuntresses", EnvReadInt(player, "MaxHuntresses") + 10);

EnvWriteString(player, "Increase Javelin production", "researched");