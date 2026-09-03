//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

.AddSentries(CLAMP(.GetMaxSentries() - .GetNumSentries(), 0, 10));

This.PlaySound("Data/Sound Entities/TownhallHireSentries.xml");