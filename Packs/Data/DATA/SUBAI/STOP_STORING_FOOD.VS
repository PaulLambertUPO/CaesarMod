//void, Obj This

Settlement this;

this = This.AsBuilding().settlement;

EnvWriteInt(this, "IsStoring", 0);

.SetFood(.food + EnvReadInt(this, "FoodStorage"));

EnvWriteInt(this, "FoodStorage", 0);