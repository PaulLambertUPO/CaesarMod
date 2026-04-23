//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

.AddSentries(CLAMP(.GetMaxSentries() - .GetNumSentries(), 0, 10));