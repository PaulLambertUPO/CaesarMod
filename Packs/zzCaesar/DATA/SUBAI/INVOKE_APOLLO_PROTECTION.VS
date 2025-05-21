//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

EnvWriteString(this, "ApolloProtectionP" + .player, "researched");

EnvWriteInt(this, "ApolloProtectionTimer", 120);

PlaySound("Data/Sound Entities/StonehengeSpell.xml");