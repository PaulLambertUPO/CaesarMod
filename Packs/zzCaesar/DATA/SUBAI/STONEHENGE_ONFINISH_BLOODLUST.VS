//void, Obj This, bool bCanceled

ObjList ol;
int i;

if (bCanceled)
	This.AsBuilding().GlobalSpellStop();

ol = GetSettlements("Stonehenge", 0);
ol.Remove(This);

for (i = ol.count - 1; i >= 0; i -= 1)
	if (ol[i].command == "bloodlust")
		return;

SetGlobalBloodlust(false);