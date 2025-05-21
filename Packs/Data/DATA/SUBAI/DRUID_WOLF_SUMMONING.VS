// void, Obj This

Druid this;
Unit u;
this = This.AsDruid();
if (!.IsValid()) return;

.PlayAnim(19, .pos);
u=Place("WolfSummoned", .posRH, .player);
u.SetStamina(10);
SwapSelectedObj(this, u);
.SetSummoningDeath(true);
.Damage(.health);